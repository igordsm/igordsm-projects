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

class UserStatistics(db.Model):
    player = db.UserProperty()
    games_played = db.IntegerProperty()
    games_over_xmpp = db.IntegerProperty()
    times_hanged = db.IntegerProperty()
    
    @staticmethod
    def add_to_user(user, win=True, xmpp=False):
        pass
    
class Word(db.Model):
    word = db.StringProperty()
    hint = db.StringProperty(default='')
    
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
        if len(self.right_letters) == len(set(self.word)):
            self.finished = True
        self.put()
        
    def won(self):
        return self.finished and len(self.right_letters) == len(set(self.word))
    
    @staticmethod
    def get_last_game_from(user):
        all_from_user = Game.all().filter('player =', user).filter('finished =', False)
        return all_from_user.get()
    
class IndexHandler(webapp.RequestHandler):
    def get(self):
        self.response.out.write(template.render(os.path.dirname(__file__) + "/templates/index.html", {}))


class GameLetterHandler(webapp.RequestHandler):
    def get(self, game_id, letter):
        self.response.out.write('YEAH' + letter)
        g = Game.get_by_id(game_id)
        g.try_letter(letter)
        #return game state
        
        
def main():
    application = webapp.WSGIApplication([('/', IndexHandler),
                                          ('/_ah/xmpp/message/chat/', ChatGameHandler),
                                          (r'/([0-9]*)/try_letter/([a-z])', GameLetterHandler)],
                                         debug=True)
    util.run_wsgi_app(application)


if __name__ == '__main__':
    main()

