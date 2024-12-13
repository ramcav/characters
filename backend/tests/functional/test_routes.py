import json
from character_api import app, db
from character_api.models import Character
import pytest


def test_dummy_wrong_path(testing_client):
    """
    GIVEN a Flask application
    WHEN the '/wrong_path' page is requested (GET)
    THEN check the response is 404
    """
    response = testing_client.get('/wrong_path')
    assert response.status_code == 404

def test_get_characters(testing_client):
    """
    GIVEN a Flask application
    WHEN the '/characters' page is requested (GET)
    THEN check the response is valid
    """
    # Use the existing database setup with one character
    response = testing_client.get('/characters')
    data = response.get_json()
    
    assert response.status_code == 200
    assert 'characters' in data
    assert len(data['characters']) == 1
    assert data['characters'][0]['alias'] == 'alguadam' 

def test_create_character(testing_client):
    """
    GIVEN a Flask application
    WHEN the '/characters' page is posted to (POST) with a valid body
    THEN check the response is valid with status code 200
    """
    payload = {
        "alias": "hero2",
        "name": "Hero Two"
    }
    response = testing_client.post(
        '/characters',
        data=json.dumps(payload),
        content_type='application/json'
    )
    data = response.get_json()

    assert response.status_code == 200
    assert data['alias'] == "hero2"
    assert data['name'] == "Hero Two"

    # Ensure the character exists in the database
    with app.app_context():
        character = Character.query.get("hero2")
        assert character is not None
        assert character.name == "Hero Two"
