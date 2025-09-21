@tool
class_name SelectedCardUI extends TextureRect

@export var card: CardBase:
	set(value):
		card = value
		texture = card.card_texture

func SetCard(_card: CardBase) -> void:
	card = _card
