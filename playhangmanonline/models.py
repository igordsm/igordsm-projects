
from google.appengine.ext import db

import random
import string

class UserStatistics(db.Model):
    player = db.UserProperty()
    games_played = db.IntegerProperty(default=0)
    games_over_xmpp = db.IntegerProperty(default=0)
    times_hanged = db.IntegerProperty(default=0)
    
    @staticmethod
    def game_begin(user, xmpp=False):
        us = UserStatistics.all().filter('player =', user).get()
        if us:
            us.games_played += 1
            if xmpp:
                us.games_over_xmpp += 1
        else:
            us = UserStatistics(player=user)
            us.games_played = 1
            if xmpp:
                us.games_over_xmpp = 1
            us.times_hanged = 0
        us.put()
    
    @staticmethod
    def game_end(user, win=False):
        if not win:
            us = UserStatistics.all().filter('player =', user).get()
            us.times_hanged += 1
            us.put()
    
class Word(db.Model):
    word = db.StringProperty()
    hint = db.StringProperty(default='')
    
    @staticmethod
    def random():
        first = random.choice(string.lowercase)
        words = Word.all().filter('word >', first).filter('word <', chr(ord(first) + 1))
        if words.count() == 0:
            words = Word.all()
        selected = words.fetch(1, random.randint(0, words.count()-1))
        return selected[0]
    
class Game(db.Model):
    player = db.UserProperty()
    word = db.ReferenceProperty(Word)
    wrong_letters = db.StringProperty(default='')
    right_letters = db.StringProperty(default='')
    using_xmpp = db.BooleanProperty(default=False)
    date = db.DateTimeProperty(auto_now_add=True)
    finished = db.BooleanProperty(default=False)
    
    def try_letter(self, letter):
        if not letter in self.wrong_letters and not letter in self.word.word:
            self.wrong_letters += letter
        if letter in self.word.word and not letter in self.right_letters:
            self.right_letters += letter
        if len(self.wrong_letters) > 5:
            self.finished = True
        if len(self.right_letters) == len(set(self.word.word)):
            self.finished = True
        self.put()
        
    def won(self):
        return self.finished and len(self.right_letters) == len(set(self.word.word))
    
    @staticmethod
    def get_last_game_from(user):
        all_from_user = Game.all().filter('player =', user).filter('finished =', False)
        return all_from_user.get()