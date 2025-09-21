extends Control

func _ready():
	# Buton sinyallerini bağla
	$Main_Menu.pressed.connect(_on_main_menu_pressed)
	$Settings.pressed.connect(_on_settings_pressed)
	$Quit.pressed.connect(_on_quit_pressed)
	$Resume.pressed.connect(_on_resume_pressed)

func _on_resume_pressed():
	# Level 1'e geri dön (sabit yol)
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_quit_pressed():
	get_tree().quit()
