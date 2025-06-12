extends Control

@onready var scene_manager : SceneManager = get_node("/root/Main")
@onready var network : NetworkManager = get_node("/root/Main/NetworkManager")

var player_slots : Array = []
@onready var player_slot_parent = $PlayerSlotList

@onready var start_button = $StartGame

func _ready():
	pass#for slot in player_slot_parent.get_children():
		#print(slot.current_player)
		#player_slots.append(slot)

func update_ui ():
	if not visible:
		return
	
	start_button.visible = multiplayer.is_server()
	
	var player_count = len(network.current_players)
	
	for i in len(player_slots):
		var slot = player_slots[i]
		
		if i < player_count:
			slot.visible = true
			slot.update_slot_ui(network.current_players[i])
		else:
			slot.visible = false

func _on_start_game_button_pressed():
	scene_manager.load_game_scene.rpc()

func _on_quit_game_pressed() -> void:
	if multiplayer.is_server():
		$"../../.."._open_main_menu()
	
	multiplayer.multiplayer_peer.close()
