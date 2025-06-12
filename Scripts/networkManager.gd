class_name  NetworkManager
extends Node

signal OnConnectedToServer
signal OnServerDisconnected

@onready var player_lobby_scene = preload("res://Scenes/Player.tscn")
@onready var spawned_nodes =$SpawnedNodes
#@onready var game_manager : GameManager = get_node("/root/Main/GameScene")


var local_username: String
var current_players: Array = []

# start a server
func start_host (port : int):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, 8)
	multiplayer.multiplayer_peer = peer
	
	current_players = []
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	_on_player_connected(multiplayer.get_unique_id())
	_connected_to_server()

# join a server
func start_client (ip : String, port : int):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	
	current_players = []
	
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)

# kick a player from the game
@rpc("any_peer", "call_local", "reliable")
func disconnect_player (player_id : int):
	multiplayer.multiplayer_peer.disconnect_peer(player_id)

# called on SERVER when a new player joins
func _on_player_connected (id : int):
	print("New player has joined!")
	var player = player_lobby_scene.instantiate()
	player.name = str(id)
	spawned_nodes.add_child(player, true)

# called on SERVER when a player leaves
func _on_player_disconnected (id : int):
	var node = spawned_nodes.get_node(str(id))
	
	if current_players.has(node):
		remove_player_from_list(node)
	
	if node:
		node.queue_free()

# called on CLIENT when you connect to server
func _connected_to_server ():
	OnConnectedToServer.emit()

# called on CLIENT when you fail to join a server
func _connection_failed ():
	pass

# called on CLIENT when the server disconnects
func _server_disconnected ():
	OnServerDisconnected.emit()

func add_player_to_list (player : Player):
	current_players.append(player)

func remove_player_from_list (player : Player):
	current_players.erase(player)
