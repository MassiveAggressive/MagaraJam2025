class_name GameManagerSingle extends Node

signal PlayerStateReady(PlayerStateBase)
signal PlayerReady(Node)

var current_game_manager: GameManagerBase

@export var level_queue: Array[String]
@export var levels: Dictionary[String, PackedScene]
var current_level_name: String = ""
var current_level: PackedScene

var player_state_node: PlayerStateBase
var player_1_node: Node
var player_2_node: Node

func SetGameManager(game_manager: GameManagerBase) -> void:
	current_game_manager = game_manager

func GetGameManager() -> GameManagerBase:
	return current_game_manager

func SetPlayerState(new_player_state_node: PlayerStateBase) -> void:
	player_state_node = new_player_state_node
	PlayerStateReady.emit(player_state_node)

func GetPlayerState() -> PlayerStateBase:
	return player_state_node

func SetPlayer(new_player_node: Node, player_index: int) -> void:
	if player_index == 0:
		player_1_node = new_player_node
		PlayerReady.emit(player_1_node)
	elif player_index == 1:
		player_2_node = new_player_node
		PlayerReady.emit(player_2_node)
	
func GetPlayer(player_index: int) -> Node:
	if player_index == 0:
		return player_1_node
	if player_index == 1:
		return player_2_node
	return null

func GetLevel(card_name: String) -> String:
	return current_level_name

func SetLevel(level_name: String) -> void:
	current_level_name = level_name
	current_level = levels[current_level_name]
	SceneManager.ChangeScene(current_level)

func GetNextLevel() -> String:
	if current_level_name == "":
		current_level_name = level_queue[0]
		return current_level_name
	return level_queue[level_queue.find(current_level_name) + 1]
