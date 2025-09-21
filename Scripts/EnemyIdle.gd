# EnemyIdle.gd - Idle state
extends "res://Scripts/BaseState.gd"

func enter():
	enemy.velocity = Vector2.ZERO
	enemy._play_animation("EnemyIdle")
	# Disable Area2D collision in idle state
	set_area2d_monitoring(false)

func update(delta: float):
	if player == null:
		return
	
	var dist = enemy.global_position.distance_to(player.global_position)
	
	# Check if player is in detection range and has line of sight
	if dist <= enemy.follow_distance and has_line_of_sight():
		enemy.change_state(preload("res://Scripts/EnemyPursuing.gd"))
