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


class GameLetterHandler(webapp.RequestHandler):
    def get(self, game_id, letter):
        g = Game.get_by_id(game_id)
        g.try_letter(letter)
        s = "{wrong: '" + g.wrong_letters + "', right: '" + g.right_letters + "', word: '" + g.word.word + "'}"
        self.response.out(s)
        
class GameHandler(webapp.RequestHandler):
    def get(self):
        w = Word.random()
        #w.put()
        g = Game(word=w, player=users.User(msg.sender), using_xmpp=False)
        g.save()
    
    def post(self):
        game_id = self.request.get('game_id')
        letter = self.request.get('letter')
        g = Game.get_by_id(game_id)
        g.try_letter(letter)
        s = "{wrong: '" + g.wrong_letters + "', right: '" + g.right_letters + "', word: '" + g.word.word + "'}"
        self.response.out.write(s)
        
        
def main():
    application = webapp.WSGIApplication([('/', IndexHandler),
                                          ('/_ah/xmpp/message/chat/', ChatGameHandler),
                                          (r'/([0-9]*)/try_letter/([a-z])', GameLetterHandler),
                                          ('/play/', GameHandler)],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()

