extends Node3D

@export var Speed: float
var player_in_inner_radius :Array[PlayerChar] = []
var player_in_outter_radius :Array[PlayerChar] = []


func _process(delta: float) -> void:
	if multiplayer.is_server():
		for player in player_in_outter_radius:
			if player_in_inner_radius.find(player) == -1:
				player.take_damage()

func _on_life_time_timeout() -> void:
	queue_free()


func _on_inner_radius_body_entered(body: Node3D) -> void:
	if multiplayer.is_server():
		if body.is_in_group("Player"):
			player_in_inner_radius.append(body)


func _on_inner_radius_body_exited(body: Node3D) -> void:
	if multiplayer.is_server():
		if body.is_in_group("Player"):
			player_in_inner_radius.erase(body)


func _on_outer_radius_body_entered(body: Node3D) -> void:
	print(body.name, " entered outter radius")
	if multiplayer.is_server():
		if body.is_in_group("Player"):
			player_in_outter_radius.append(body)


func _on_outer_radius_body_exited(body: Node3D) -> void:
	if multiplayer.is_server():
		if body.is_in_group("Player"):
			player_in_outter_radius.erase(body)
