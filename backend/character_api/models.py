from character_api import db
from datetime import datetime
import string, random

class Character(db.Model):
    __tablename__ = 'characters'

    alias = db.Column(db.String(16), nullable=False, primary_key=True)
    name = db.Column(db.String(32),nullable=False)
    level = db.Column(db.Integer, default = 1)
    health = db.Column(db.Float, default= 100.0)
    strength = db.Column(db.Float, default = 5.0)
    defense =  db.Column(db.Float, default = 5.0)
    speed =  db.Column(db.Float, default = 5.0)

    def __repr__(self):
        return f'Character({self.name}, level={self.level}, health={self.health}, strength={self.strength}, defense={self.defense}, speed={self.speed})'

    def __init__(self, alias, name):
        self.alias = alias
        self.name = name
        self.level = 1
        self.health = 100.0
        self.strength = 5.0
        self.defense = 5.0
        self.speed = 5.0