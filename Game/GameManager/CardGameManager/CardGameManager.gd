class_name CardGameManager extends GameManagerBase

@export var all_cards: Dictionary[String, CardBase]
var selected_cards: Array[CardBase]

var card_selection_ui_scene: PackedScene = preload("uid://damqesyd2f7vj")
var card_selection_ui: CardSelectionUI

var selected_card_ui_scene: PackedScene = preload("uid://mnyo04prceht")
var selected_card_uis: Array[TextureRect]

func _ready() -> void:
	card_selection_ui = card_selection_ui_scene.instantiate()
	Canvas.AddChild(card_selection_ui)
	
	CreateCards()

func CreateCards() -> void:
	GameInstance.selected_cards.clear()
	var cards: Array[CardBase] = GameInstance.all_cards.duplicate()
	
	for card in all_cards.values():
		var selected_card_ui: SelectedCardUI = selected_card_ui_scene.instantiate()
		selected_card_ui.SetCard(card)
		card_selection_ui.AddChild(selected_card_ui)
