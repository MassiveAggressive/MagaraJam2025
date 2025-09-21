class_name GameInstanceBase
extends Node

@export var default_map_scene: PackedScene

var map_node: MapBase

@export var all_cards: Array[CardBase]
var selected_cards: Array[CardBase]

func _enter_tree() -> void:
	SceneManager.ChangeScene(default_map_scene)
