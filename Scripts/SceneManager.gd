extends Node3D
class_name SceneManager

var game_scene: PackedScene = preload("res://Scenes/GameScene.tscn")
var menu_scene: PackedScene = preload("res://Scenes/Menu.tscn")
@onready var network: NetworkManager = get_node("/root/Main/NetworkManager")

var menu
var game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game = game_scene.instantiate()
	menu = menu_scene.instantiate()
	add_child(menu)



func load_menu_scene ():
	remove_child(game)
	add_child(menu)


func load_game_scene():
	remove_child(menu)
	add_child(game)
