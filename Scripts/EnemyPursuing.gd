# EnemyPursuing.gd - Pursuing state
extends "res://Scripts/BaseState.gd"

func enter():
	enemy._play_animation("EnemyRun")
	# Disable Area2D collision in pursuing state
	set_area2d_monitoring(false)

func update(delta: float):
	if player == null:
		enemy.change_state(preload("res://Scripts/EnemyIdle.gd"))
		return
	
	var dist = enemy.global_position.distance_to(player.global_position)
	print("DEBUG PURSUING: Distance: ", dist, " Attack distance: ", enemy.attack_distance)
	
	# Check if player is close enough to attack
	if dist <= enemy.attack_distance:
		print("DEBUG PURSUING: Switching to ATTACK state!")
		enemy.change_state(preload("res://Scripts/EnemyAttack.gd"))
		return
	
	# Check if player is too far or lost line of sight
	if dist > enemy.follow_distance or not has_line_of_sight():
		print("DEBUG PURSUING: Switching to IDLE state!")
		enemy.change_state(preload("res://Scripts/EnemyIdle.gd"))
		return
	
	# Move towards player but maintain minimum distance
	var direction = (player.global_position - enemy.global_position).normalized()
	var stop_distance = enemy.attack_distance + 50  # Attack distance + 50 buffer
	
	print("DEBUG PURSUING: Stop distance: ", stop_distance, " Current distance: ", dist)
	
	if dist > stop_distance:
		# Player uzaksa, yaklaş
		enemy.velocity = direction * enemy.speed
		print("DEBUG PURSUING: Moving towards player")
	else:
		# Player yakınsa, dur ama ATTACK state'e geçme
		enemy.velocity = Vector2.ZERO
		print("DEBUG PURSUING: Enemy stopped - waiting for player to get closer!")
	
	# Flip sprite based on movement direction
	if enemy.has_node("AnimatedSprite2D"):
		enemy.get_node("AnimatedSprite2D").flip_h = direction.x > 0
	
	enemy.move_and_slide()
