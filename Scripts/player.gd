extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var attack_scene: PackedScene
@export var attack_cooldown: float = 0.7
@export var health: int = 3
@export var is_player1: bool = true

var can_attack: bool = true
var has_key: int = 0
var canTeleport: bool = false

# Attack sesleri için array
var attack_sounds: Array = ["scissors1", "scissors2", "scissors3", "scissors4", "scissorscombo"]
var current_attack_index: int = 0

func _ready():
	add_to_group("player")
	if is_player1:
		add_to_group("player1")
	else:
		add_to_group("player2")

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_try_attack()

func _handle_movement(delta: float) -> void:
	var move_left_action = "Move Left" if is_player1 else "ui_left"
	var move_right_action = "Move Right" if is_player1 else "ui_right"
	var jump_action = "jump" if is_player1 else "ui_up"
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = jump_velocity

	var dir = Input.get_axis(move_left_action, move_right_action)
	if dir != 0:
		velocity.x = dir * speed
		$AnimatedSprite2D.flip_h = dir < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed * delta)

	move_and_slide()

func _try_attack() -> void:
	if not can_attack or attack_scene == null:
		return
	can_attack = false
	_perform_attack()
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _perform_attack() -> void:
	# Sıralı attack sesi çal
	play_next_attack_sound()
	
	var weapon_instance = attack_scene.instantiate()
	var attack_direction = Vector2(1, 0)
	var attack_offset = Vector2(100, 0)
	
	if $AnimatedSprite2D.flip_h:  
		attack_direction.x = -1  
		attack_offset.x = -attack_offset.x 
	else:  
		attack_direction.x = 1  
		attack_offset.x = attack_offset.x  
	
	weapon_instance.setup_weapon(self, attack_direction, attack_offset)
	get_parent().add_child(weapon_instance)

func play_next_attack_sound():
	# Mevcut sesi çal
	SfxManager.play(attack_sounds[current_attack_index])
	
	# Sonraki sese geç
	current_attack_index += 1
	
	# Array sonuna geldiyse başa dön
	if current_attack_index >= attack_sounds.size():
		current_attack_index = 0

func take_damage(damage_amount: int):
	print("Player took ", damage_amount, " damage!")
	health -= damage_amount
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")

func collect_key():
	if has_key == 0:
		has_key = 1
		canTeleport = true
		print("Key collected by ", "Player1" if is_player1 else "Player2")
		return true
	else:
		print("Player already has a key!")
		return false
