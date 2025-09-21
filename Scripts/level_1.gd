extends Node2D

func _ready() -> void:
	$Fade_transition/AnimationPlayer.play("fade_out")

func _input(event):
	
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/pause_menu.tscn")

func on_player_death():
	
	get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")
	
	await get_tree().process_frame
	var death_menu = get_tree().current_scene
	if death_menu.has_method("set_previous_scene"):
		death_menu.set_previous_scene("res://Scenes/level_1.tscn")
