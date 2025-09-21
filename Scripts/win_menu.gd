extends Control

func _ready():
	# Buton sinyallerini bağla
	$Main_Menu.pressed.connect(_on_main_menu_pressed)
	
	$Quit.pressed.connect(_on_quit_pressed)


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main Menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
