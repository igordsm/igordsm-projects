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

class UserStatistics(db.Model):
    player = db.UserProperty()
    games_played = db.IntegerProperty()
    games_over_xmpp = db.IntegerProperty()
    times_hanged = db.IntegerProperty()
    
    @staticmethod
    def add_to_user(user, win=True, xmpp=False):
        pass
    
class Game(db.Model):
    player = db.UserProperty()
    word = db.StringProperty()
    wrong_letters = db.StringProperty(default='')
    right_letters = db.StringProperty(default='')
    using_xmpp = db.BooleanProperty(default=False)
    date = db.DateTimeProperty(auto_now_add=True)
    finished = db.BooleanProperty(default=False)
    
    def try_letter(self, letter):
        if not letter in self.wrong_letters and not letter in self.word:
            self.wrong_letters += letter
        if letter in self.word and not letter in self.right_letters:
            self.right_letters += letter
        if len(self.wrong_letters) > 5:
            self.finished = True
            #perdeu
        if len(self.right_letters) == len(set(self.word)):
            self.finished = True
        self.put()
    
    @staticmethod
    def get_last_game_from(user):
        all_from_user = Game.all().filter('player =', user).filter('finished =', False)
        return all_from_user.get()
    
class IndexHandler(webapp.RequestHandler):
    def get(self):
        self.response.out.write(template.render(os.path.dirname(__file__) + "/templates/index.html", {}))

        
class ChatGameHandler(webapp.RequestHandler):
    def __send_game_state(self, g, msg):
        m = u'    ____\n'
        m+= u'   |   |\n'
        m+= u'   |   '
        if len(g.wrong_letters) >= 1: m+= u'0'
        m+= '\n'
        m+= u'   |   '
        if len(g.wrong_letters) >= 2: m+= u'/'
        if len(g.wrong_letters) >= 3: m+= u'|'
        if len(g.wrong_letters) >= 4: m+= u'\\'
        m+= '\n'
        m+= u'   |   '
        if len(g.wrong_letters) >= 5: m+= u'/ '
        if len(g.wrong_letters) > 5: m+= u'\\'
        m+= '\n'
        m+= '__|__\n'
        msg.reply(m)
        m = ''
        for c in g.word:
            if c in g.right_letters:
                m += c + ' '
            else:
                m += '__ '
        msg.reply(m + '\n')
        msg.reply('Letters tried: ' + g.wrong_letters)
        
    def post(self):
        msg = xmpp.Message(self.request.POST)
        curr = Game.get_last_game_from(users.User(msg.sender))
        if curr:
            letter = [l for l in msg.body.lower() if l in string.ascii_lowercase]
            if len(letter) > 0:
                g.try_letter(letter[0])
            self.__send_game_state(curr, msg)
            if g.finished:
                msg.reply(u'You Lost')
        else:
            if msg.body.lower() == 'new game' or msg.body.lower() == 'yes':
                g = Game(word='bla', player=users.User(msg.sender), using_xmpp=True)
                g.save()
                msg.reply(u'New Game started\n')
                self.__send_game_state(g, msg)
        
def main():
    application = webapp.WSGIApplication([('/', IndexHandler),
                                          ('/_ah/xmpp/message/chat/', ChatGameHandler)],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()

