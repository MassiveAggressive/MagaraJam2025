class_name InGameGameManager extends GameManagerBase

var selected_cards: Array[CardBase]

func _ready() -> void:
	player_state_node = default_player_state_scene.instantiate()
	GameManager.SetPlayerState(player_state_node) 
	get_tree().current_scene.add_child(player_state_node)
	
	selected_cards = (get_tree().current_scene as MapBase).selected_cards
	for card in selected_cards:
		(player_state_node as InGamePlayerState).inventory.AddItemToInventory(card)
	
	player_1_node = default_player_scene.instantiate()
	player_1_node.player_index = 0
	GameManager.SetPlayer(player_1_node, 0) 
	get_tree().current_scene.add_child(player_1_node)
	if !SpawnPoints.spawn_points.is_empty():
		player_1_node.global_position = SpawnPoints.spawn_points[0].global_position
	
	player_state_node.SetPlayerNode(player_1_node, 0)
	
	player_2_node = default_player_scene.instantiate()
	player_1_node.player_index = 1
	GameManager.SetPlayer(player_2_node, 1) 
	get_tree().current_scene.add_child(player_2_node)
	if !SpawnPoints.spawn_points.is_empty():
		player_2_node.global_position = SpawnPoints.spawn_points[1].global_position
	
	player_state_node.SetPlayerNode(player_2_node, 1)

func LevelEnded() -> void:
	SceneManager.ChangeScene(preload("uid://bjurvwswq8sf5"))
