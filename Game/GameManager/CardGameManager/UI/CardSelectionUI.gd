class_name CardSelectionUI extends Control

var tower: bool = false

func AddChild(control: Control) -> void:
	$HBoxContainer.add_child(control)

func OnStartGameButtonPressed() -> void:
	GameManager.SetLevel(GameManager.GetNextLevel())
