extends Node3D

@onready var attack_Spawn = $AttackOrigin
@onready var aoe_attack = preload("res://Scenes/aoe_attack.tscn")

@export var players_in_range: Array[PlayerChar] = []
@export var player_targeted: PlayerChar
@export var distance_to_target: float

func _ready() -> void:
	if not multiplayer.is_server():
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	selecting_current_target()
	if player_targeted:
		look_at(player_targeted.transform.origin, Vector3.UP)


func selecting_current_target():
	if !players_in_range.is_empty():
		for player in players_in_range:
			print("distance to ",player.name," : ",player.position.distance_to(position))
			if !player_targeted:
				player_targeted = player
				print("new target :",player.name )
				return
			if player.name != player_targeted.name:
				if player.position.distance_to(position) < player_targeted.position.distance_to(position):
					distance_to_target = player.position.distance_to(position)
					player_targeted = player
					print("new target :",player.name )


func _on_area_3d_body_entered(body: Node3D) -> void:
	print(" body entered : ", body.name)
	if body.is_in_group("Player"):
		players_in_range.append(body)


func _on_area_3d_body_exited(body: Node3D) -> void:
	print(" body exited : ", body.name)
	if body.is_in_group("Player"):
		players_in_range.erase(body)
		if player_targeted and  body.name == player_targeted.name:
			player_targeted = null
