extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var attack_scene: PackedScene
@export var attack_cooldown: float = 0.7
@export var health: int = 3

var can_attack: bool = true
var has_key: int = 0  # 0 = key yok, 1 = key var
var canTeleport: bool = false

func _ready():
	add_to_group("player")
	add_to_group("player2")  # Ok tuşları player

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_try_attack()

func _handle_movement(delta: float) -> void:
	# Ok tuşları kontrolleri
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_velocity

	var dir = Input.get_axis("ui_left", "ui_right")
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

func take_damage(damage_amount: int):
	print("Player took ", damage_amount, " damage!")
	health -= damage_amount
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/death_menu.tscn")

func collect_key():
	if has_key == 0:  # Key yoksa
		has_key = 1
		canTeleport = true
		print("Key collected by Player2 (Arrow Keys)")
		return true
	else:
		print("Player2 already has a key!")
		return false
