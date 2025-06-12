extends Control

@onready var network : NetworkManager = get_node("/root/Main/NetworkManager")
@onready var scene_manager: SceneManager = get_node("/root/Main")
@onready var main_screen =$CanvasLayer/Panel/MainMenu
@onready var lobby_screen = $CanvasLayer/Panel/Lobby

func _ready():
	network.OnConnectedToServer.connect(scene_manager.load_game_scene)
	#network.OnConnectedToServer.connect(_open_lobby)
	network.OnServerDisconnected.connect(scene_manager.load_menu_scene)

func _open_main_menu ():
	main_screen.visible = true
	lobby_screen.visible = false

func _open_lobby ():
	main_screen.visible = false
	lobby_screen.visible = true

func close_main_menu():
	self.visible = false
	$CanvasLayer.visible = false
