class_name HotkeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label as Label
@onready var button: Button = $HBoxContainer/Button as Button

@export var action_name : String = "Move Left"

var is_rebinding = false

func _ready() -> void:
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	
	# Connect button signal
	button.pressed.connect(_on_button_pressed)

func set_action_name() -> void:
	label.text = "unassigned"
	
	match action_name:
		"Move Left":
			label.text = "Move Left"
		"Move Right":
			label.text = "Move Right"
		"jump":
			label.text = "Jump"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	
	# Check if the action has any events assigned
	if action_events.size() > 0:
		var action_event = action_events[0]
		var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
		button.text = "%s" % action_keycode
	else:
		button.text = "None"

func _on_button_pressed() -> void:
	if not is_rebinding:
		start_rebinding()
	else:
		cancel_rebinding()

func start_rebinding() -> void:
	is_rebinding = true
	button.text = "Press any key..."
	set_process_unhandled_key_input(true)

func cancel_rebinding() -> void:
	is_rebinding = false
	set_process_unhandled_key_input(false)
	set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	if is_rebinding and event is InputEventKey and event.pressed:
		# Clear existing events for this action
		InputMap.action_erase_events(action_name)
		
		# Add the new key
		InputMap.action_add_event(action_name, event)
		
		# Update button text
		var keycode = OS.get_keycode_string(event.physical_keycode)
		button.text = "%s" % keycode
		
		# Stop rebinding
		is_rebinding = false
		set_process_unhandled_key_input(false)
