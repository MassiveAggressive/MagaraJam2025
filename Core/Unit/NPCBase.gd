class_name NPCBase extends UnitBase

@export var speed: float = 120.0
@export var follow_distance: float = 1000.0   
@export var attack_distance: float = 200.0    

var player: Node2D = null

func _ready() -> void:
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	
	if has_node("Area2D"):
		get_node("Area2D").body_entered.connect(_on_body_entered)
	
	
	_play_animation("EnemyIdle")

func _physics_process(delta: float) -> void:
	if player == null:
		_play_animation("EnemyIdle")
		return
	
	var dist = global_position.distance_to(player.global_position)
	
	
	if dist <= follow_distance:
		
		var direction = (player.global_position - global_position).normalized()
		
		if dist > attack_distance:
			# distance daha uzaksa yaklasssin diye
			velocity = direction * speed
			_play_animation("EnemyRun")
		else:
			# Player yakınsa, dur
			velocity = Vector2.ZERO
			_play_animation("EnemyAttack")
		
		# Flip icin
		if has_node("AnimatedSprite2D"):
			get_node("AnimatedSprite2D").flip_h = direction.x > 0
	else:
		# Player uzaksa durup idle icin 
		velocity = Vector2.ZERO
		_play_animation("EnemyIdle")
	
	move_and_slide()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("Enemy hit player!")
		
		# Trigger camera shake
		for cam in get_tree().get_nodes_in_group("camera"):
			if cam and cam.has_method("trigger_shake"):
				cam.trigger_shake()

func _play_animation(anim_name: String) -> void:
	if has_node("AnimatedSprite2D"):
		var anim_sprite = get_node("AnimatedSprite2D")
		if anim_sprite.animation != anim_name:
			anim_sprite.play(anim_name)
