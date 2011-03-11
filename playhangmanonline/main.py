#coding: utf-8
#!/usr/bin/env python

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

class GameHandler(webapp.RequestHandler):
    def get(self):
        if users.get_current_user():
            curr = Game.get_last_game_from(users.get_current_user())
            if not curr:
                w = Word.random()
                curr = Game(word=w, player=users.get_current_user(), using_xmpp=False)
                curr.put()
                UserStatistics.game_begin(users.get_current_user())
            self.response.out.write(template.render(os.path.dirname(__file__) + "/templates/play.html", 
            {'key': str(curr.key()),
             'word': curr.word.word,
             'hint': curr.word.hint
            }))
        else:
            self.redirect(users.create_login_url(self.request.uri))

    def post(self):
        wrong_letters = self.request.get('wrong_letters')
        right_letters = self.request.get('right_letters')
        game_key = self.request.get('game_key')
        g = Game.get_by_id(db.Key(game_key).id())
        if g:
            g.finished = True
            g.wrong_letters = wrong_letters
            g.right_letters = right_letters
            g.put()
            UserStatistics.game_end(users.get_current_user(), g.won())
        else:
            pass
                        
            
def main():
    application = webapp.WSGIApplication([('/', IndexHandler),
                                          ('/_ah/xmpp/message/chat/?', ChatGameHandler),
                                          ('/play/?', GameHandler),
                                          ],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()

