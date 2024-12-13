import pytest
from character_api.models import Character
from character_api import db, app



# conftest.py
import pytest
from character_api import db, app
from character_api.models import Character

@pytest.fixture(scope='module')
def testing_client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'

    with app.app_context():
        db.create_all()
        
        if not Character.query.get('alguadam'):
            character = Character('alguadam', 'Alvaro Guadamillas')
            db.session.add(character)
            db.session.commit()

    with app.test_client() as testing_client:
        yield testing_client

    with app.app_context():
        db.drop_all()
