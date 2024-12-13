from flask import Flask, request
from character_api import db, app
from character_api.models import Character

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/characters', methods=['POST'])
def create_character():
    alias = request.json['alias']
    if not Character.query.get(alias):
        name = request.json['name']
        character = Character(alias, name)
        db.session.add(character)
        db.session.commit()
        return format_character(character)
    else:
        return "Character already exists"

@app.route('/characters', methods=['GET'])
def get_characters():
    characters = Character.query.all()
    return {'characters': [format_character(character) for character in characters]}

@app.route('/characters/<string:alias>', methods=['GET'])
def get_character(alias):
    character = Character.query.get(alias)
    return format_character(character)

@app.route('/characters/<string:alias>', methods=['PUT'])
def update_character(alias):
    character = Character.query.get(alias)
    if not character:
        return "Character not found"
    else:
        character.alias = request.json['alias']
        db.session.commit()
        return format_character(character)

@app.route('/characters/<string:alias>', methods=['DELETE'])
def delete_character(alias):
    character = Character.query.get(alias)
    if not character:
        return "Character not found"
    else:
        db.session.delete(character)
        db.session.commit()
        return format_character(character)

def format_character(character):
    return {
        'alias' : character.alias,
        'name' : character.name,
        'level' : character.level,
        'health': character.health,
        'strength': character.strength,
        'defense': character.defense,
        'speed': character.speed
    }