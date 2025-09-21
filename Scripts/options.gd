extends Control

var button_type = null

@onready var exit_button: Button = $MarginContainer/VBoxContainer/Exit_Button as Button

func _ready() -> void:
	$Fade_transition/AnimationPlayer.play("fade_out")
	# Connect the animation finished signal
	$Fade_transition/AnimationPlayer.animation_finished.connect(_on_animation_finished)
	
func _play_button_sfx():
	SfxManager.play("button_click")

func _on_exit_button_pressed() -> void:
	_play_button_sfx()
	button_type = "Exit_Button"
	$Fade_transition.show()
	$Fade_transition/AnimationPlayer.play("fade_in")

# Animation finished callback
func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in" and button_type == "Exit_Button":
		get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")
