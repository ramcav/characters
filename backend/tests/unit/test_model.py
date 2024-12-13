from character_api.models import Character

def test_create_character():
    """
    GIVEN a Character model
    WHEN a new Character is created
    THEN check the alias, name, level, health, strength, defense, and speed are defined correctly
    """
    # Create a new character instance
    alias = "hero_alias"
    name = "Hero Name"
    character = Character(alias=alias, name=name)
    
    # Assertions
    assert character.alias == alias
    assert character.name == name
    assert character.level == 1  # Default level
    assert character.health == 100.0  # Default health
    assert character.strength == 5.0  # Default strength
    assert character.defense == 5.0  # Default defense
    assert character.speed == 5.0  # Default speed
