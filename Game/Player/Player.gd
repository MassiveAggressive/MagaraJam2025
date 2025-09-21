class_name Player extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = 400.0
@export var gravity: float = 980.0

@export var dash_speed: float = 600.0
@export var dash_time: float = 0.15
@export var dash_cooldown: float = 0.4

var facing_right: bool = true
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_dir: int = 1

var gravity_dir: int = 1

var input_keys: Dictionary[Util.EInputKey, StringName] = {
	Util.EInputKey.MOVERIGHT: "MoveRight1",
	Util.EInputKey.MOVELEFT: "MoveLeft1",
	Util.EInputKey.JUMP: "Jump1",
	Util.EInputKey.DASH: "Dash1"
}

var state: Util.EState = Util.EState.IDLE
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var max_health: float = 100.0
@export var health: float = 100.0

var dead: bool = false
var collectable_revive_scene: PackedScene = preload("uid://dv050bcflli0s")
var collectable_revive: CollectableRevive

@export var attack_scene: PackedScene
@export var attack_cooldown: float = 0.7 # seconds

var can_attack: bool = true

var player_index: int = 0

func _input(event: InputEvent) -> void:
	if !dead:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				_try_attack()

func _ready() -> void:
	Gravity.GravityChanged.connect(toggle_gravity)

func _physics_process(delta: float) -> void:
	if !dead:
		_process_input()

		if is_dashing:
			_process_dash(delta)
		else:
			_process_move_and_jump(delta)
		
		up_direction = Vector2.UP * gravity_dir
		
		move_and_slide()
	
		_update_state()

func _process_input() -> void:
	var input_axis = Input.get_action_strength(input_keys[Util.EInputKey.MOVERIGHT]) - Input.get_action_strength(input_keys[Util.EInputKey.MOVELEFT])
	velocity.x = input_axis * move_speed
	
	if input_axis != 0:
		facing_right = input_axis > 0
		sprite.flip_h = !facing_right

	if Input.is_action_just_pressed(input_keys[Util.EInputKey.JUMP]) and is_on_floor() and not is_dashing:
		velocity.y = -jump_force * gravity_dir
	
	if Input.is_action_just_pressed(input_keys[Util.EInputKey.DASH]) and not is_dashing and dash_cooldown_timer <= 0.0:
		_start_dash()

func _process_move_and_jump(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * gravity_dir * delta
	
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

func _start_dash() -> void:
	is_dashing = true
	dash_timer = dash_time
	dash_cooldown_timer = dash_cooldown
	
	dash_dir = 1 if facing_right else -1
	velocity = Vector2(dash_dir * dash_speed, 0)
	state = Util.EState.DASH

func _process_dash(delta: float) -> void:
	velocity = Vector2(dash_dir * dash_speed, 0)
	
	dash_timer -= delta
	if dash_timer <= 0.0:
		_end_dash()

func _end_dash() -> void:
	is_dashing = false

func _update_state() -> void:
	if is_dashing:
		state = Util.EState.DASH
		sprite.play("Dash")
	elif is_on_floor():
		if abs(velocity.x) > 0.1:
			state = Util.EState.RUN
			sprite.play("Run")
		else:
			state = Util.EState.IDLE
			sprite.play("Idle")
	else:
		if (velocity.y * gravity_dir) < 0:
			state = Util.EState.JUMP
			sprite.play("Jump")
		else:
			state = Util.EState.FALL
			sprite.play("Fall")

func toggle_gravity():
	gravity_dir *= -1

func TakeDamage(damage: float) -> void:
	health -= damage
	health = clamp(health, 0.0, max_health)
	
	if health == 0.0:
		dead = true
		collectable_revive = collectable_revive_scene.instantiate()
		collectable_revive.global_position = global_position
		get_tree().current_scene.add_child(collectable_revive)

func Revive() -> void:
	if GameManager.GetPlayer(0) == self:
		global_position = GameManager.GetPlayer(1).global_position
	else:
		global_position = GameManager.GetPlayer(0).global_position
	
	health = max_health
	dead = false
	if collectable_revive:
		collectable_revive.queue_free()

func _try_attack() -> void:
	if not can_attack or attack_scene == null:
		return

	can_attack = false
	_perform_attack()

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _perform_attack() -> void:
	var weapon_instance = attack_scene.instantiate()
	
	var attack_direction = Vector2(1, 0)  # Default right
	var attack_offset = Vector2(100, 0)  # Attack distance in front
	
	if !facing_right:  
		attack_direction.x = -1  
		attack_offset.x = -attack_offset.x 
	else:  
		attack_direction.x = 1  
		attack_offset.x = attack_offset.x  
	
	weapon_instance.setup_weapon(self, attack_direction, attack_offset)
	
	get_parent().add_child(weapon_instance)
