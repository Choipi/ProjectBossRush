class_name GameManager
extends Node3D

@onready var network : NetworkManager = get_node("/root/Main/NetworkManager")

var player_char_scene = preload("res://Scenes/Player.tscn")
@onready var spawner = $MultiplayerSpawner

var players_in_game : int = 0
var current_characters : Array = []

func _ready():
	pass
	#im_in_game.rpc(multiplayer.get_unique_id())

# when a player joins the game scene, tell the server
# when all players are in-game, spawn them in
#@rpc("any_peer", "call_local", "reliable")
#func im_in_game (id : int):
	#if multiplayer.is_server():
		#players_in_game += 1
		#_spawn_players()

func _spawn_players (id: int):
	for player in network.current_players:
		if player.name.to_int() == id:
			_spawn_player_character(player)

func _spawn_player_character (player : Player):
	var char_ = player_char_scene.instantiate()
	char_.name = player.name
	char_.position = Vector3(0, 3, 0)
	spawner.add_child(char_, true)
	current_characters.append(char_)
