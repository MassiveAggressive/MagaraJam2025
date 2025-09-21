extends Area2D

@export var next_scene_path: String = ""  # You Win sahnesi

var players_in_gate: Array = []

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not players_in_gate.has(body):
			players_in_gate.append(body)
			print("Player entered gate - Total: ", players_in_gate.size())
			print("Player groups: ", body.get_groups())
			print("Player canTeleport: ", body.canTeleport)
		_check_gate()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if players_in_gate.has(body):
			players_in_gate.erase(body)
			print("Player exited gate - Total: ", players_in_gate.size())

func _check_gate():
	print("=== GATE CHECK ===")
	print("Players in gate: ", players_in_gate.size())
	
	# 2 player var mı?
	if players_in_gate.size() != 2:
		print("Need 2 players, have: ", players_in_gate.size())
		return
	
	# Her ikisinin de canTeleport = true mu?
	var player1_can_teleport = false
	var player2_can_teleport = false
	
	for player in players_in_gate:
		print("Checking player: ", player.name)
		print("Player groups: ", player.get_groups())
		print("Player canTeleport: ", player.canTeleport)
		
		if player.is_in_group("player1") and player.canTeleport:
			player1_can_teleport = true
			print("Player1 can teleport!")
		elif player.is_in_group("player2") and player.canTeleport:
			player2_can_teleport = true
			print("Player2 can teleport!")
	
	print("Player1 can teleport: ", player1_can_teleport)
	print("Player2 can teleport: ", player2_can_teleport)
	
	# Her ikisi de true ise sahne değiştir
	if player1_can_teleport and player2_can_teleport:
		print("Both players can teleport! Loading next level...")
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("Gate condition not met!")
