#coding: utf-8
#!/usr/bin/env python
#
# Copyright 2007 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import xmpp
from google.appengine.api import users
from google.appengine.ext.webapp import util
from google.appengine.ext.webapp import template

import os
import datetime
import string

from chat_handler import ChatGameHandler
from models import *
    
class IndexHandler(webapp.RequestHandler):
    def get(self):
        self.response.out.write(template.render(os.path.dirname(__file__) + "/templates/index.html", {}))

class GameIndex(webapp.RequestHandler):
    def get(self):
        self.response.out.write(template.render(os.path.dirname(__file__) + "/templates/play.html", {}))


class GameLetterHandler(webapp.RequestHandler):
    def get(self, game_id):
        self.get(game_id, '')
        
    def get(self, game_id, letter):
        g = Game.get_by_id(db.Key(game_id).id())
        if letter and not g.finished:
            g.try_letter(letter)
        m = m = u'   ___<br>'
        m+= u'  |   |<br>'
        m+= u'  |   '
        if len(g.wrong_letters) >= 1: m+= u'0'
        m+= '<br>'
        m+= u'  |  '
        if len(g.wrong_letters) >= 2: m+= u'/'
        if len(g.wrong_letters) >= 3: m+= u'|'
        if len(g.wrong_letters) >= 4: m+= u'\\'
        m+= '<br>'
        m+= u'  |  '
        if len(g.wrong_letters) >= 5: m+= u'/ '
        if len(g.wrong_letters) > 5: m+= u'\\'
        m+= '<br>'
        m+= '__|__<br>'
        b = ''
        for c in g.word.word:
            if c in g.right_letters:
                b += c + ' '
            else:
                b += '__ '
        link = '/'.join(self.request.uri.split('/')[:-1])
        self.response.out.write(template.render(os.path.dirname(__file__) + "/templates/play.html", 
            {'game_state': m, 
            'buckets': b, 
            'wrong_letters': g.wrong_letters,
            'link': link}))

class NewGameHandler(webapp.RequestHandler):
    def get(self):
        if users.get_current_user():
            w = Word.random()
            g = Game(word=w, player=users.get_current_user(), using_xmpp=False)
            g.put()
            self.redirect('/play/' + str(g.key())) 
        else:
            self.redirect(users.create_login_url(self.request.uri))
            
            
class GameHandler(webapp.RequestHandler):
    def get(self, game_key):
        if users.get_current_user():
            g = Game.get_by_id(db.Key(game_key).id())
            self.response.out.write(template.render(os.path.dirname(__file__) + "/templates/play.html", 
            {'key': game_key,
             'word': g.word.word,
             'hint': g.word.hint
            }))
        else:
            self.redirect(users.create_login_url(self.request.uri))
    
    def post(self, game_key):
        wrong_letters = self.request.get('wrong_letters')
        g = Game.get_by_id(db.Key(game_key).id())
        g.try_letter(letter)
        s = "{wrong: '" + g.wrong_letters + "', right: '" + g.right_letters + "', word: '" + g.word.word + "'}"
        self.response.out.write(s)
    
        
        
def main():
    application = webapp.WSGIApplication([('/', IndexHandler),
                                          ('/_ah/xmpp/message/chat/?', ChatGameHandler),
                                          ('/play/?', NewGameHandler),
                                          ('/play/+([a-zA-Z0-9]*)/?', GameHandler),
                                          ],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()

