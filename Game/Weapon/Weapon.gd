class_name Weapon extends Area2D

@export var damage: int = 10
@export var duration: float = 0.7
@export var knockback_force: float = 200.0

var attacker: Node2D = null
var position_offset: Vector2 = Vector2.ZERO

func _ready():
	
	if has_node("AttackSprite"):
		$AttackSprite.animation_finished.connect(_on_animation_finished)
		$AttackSprite.play()
	else:
		print("Warning: AttackSprite not found!")
	
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(duration).timeout.connect(queue_free)

func _process(delta: float):
	if attacker:
		global_position = attacker.global_position + position_offset

func _on_animation_finished():
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body != attacker and body.has_method("take_damage"):
		body.take_damage(damage)
		print("Hit ", body.name, " for ", damage, " damage!")
		
		if body is CharacterBody2D:
			var knockback_direction = (body.global_position - global_position).normalized()
			body.velocity += knockback_direction * knockback_force

func setup_weapon(attacker_node: Node2D, direction: Vector2, offset: Vector2 = Vector2.ZERO):
	attacker = attacker_node
	position_offset = offset
	
	
	global_position = attacker.global_position + position_offset
	
	
	if direction.x < 0:
		# Karakter sola bakıyor, attack'ı sola çevir
		scale.x = -1
	else:
		# Karakter sağa bakıyor, attack'ı sağa çevir
		scale.x = 1
