extends Control

@onready var scene_manager : SceneManager = get_node("/root/Main")
@onready var network: NetworkManager = get_node("/root/Main/NetworkManager")

@onready var username_input = $CanvasLayer/Panel/Username
@onready var ip_input =$CanvasLayer/Panel/IP
@onready var port_input = $CanvasLayer/Panel/Port

func _on_host_game_button_pressed() -> void:
	network.local_username = username_input.text
	network.start_host(int(port_input.text))
	

func _on_join_game_button_pressed() -> void:
	network.local_username = username_input.text
	network.start_client(ip_input.text, int(port_input.text))
	
