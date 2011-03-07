from google.appengine.ext import webapp
from google.appengine.ext import db
from google.appengine.api import xmpp
from google.appengine.api import users
from google.appengine.ext.webapp import util
from google.appengine.ext.webapp import template

import os
import datetime
import string

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
                curr.try_letter(letter[0])
            self.__send_game_state(curr, msg)
            if curr.finished:
                if curr.won():
                    msg.reply(u'You won!')
                else:
                    msg.reply(u'You Lost')
        else:
            if msg.body.lower() == 'new game' or msg.body.lower() == 'yes':
                g = Game(word='bla', player=users.User(msg.sender), using_xmpp=True)
                g.save()
                msg.reply(u'New Game started\n')
                self.__send_game_state(g, msg)
                