extends Node2D

var button_type = null

func _ready():
	MusicManager.play_track(1)  # Test1 çal (index 1)
	# Connect the animation finished signal
	$Fade_transition/AnimationPlayer.animation_finished.connect(_on_animation_finished)

# Buton click sesi
func _play_button_sfx():
	SfxManager.play("button_click")

# Quit butonu
func _on_quit_pressed() -> void:
	_play_button_sfx()
	get_tree().quit()

# Settings butonu
func _on_settings_pressed() -> void:
	_play_button_sfx()
	button_type = "Settings"
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_in")

# Start butonu
func _on_start_pressed() -> void:
	_play_button_sfx()
	button_type = "start"
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_in")

# Animation finished callback
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		if button_type == "start":
			get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
		elif button_type == "Settings":
			get_tree().change_scene_to_file("res://Scenes/options.tscn")
