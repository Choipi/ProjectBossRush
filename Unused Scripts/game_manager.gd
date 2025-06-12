extends Node

var players: Array[Player]
var local_player: Player

var max_x = 10
var max_y = 10
var score_to_win = 1

func get_random_spawn_pos():
	return Vector3(randf_range(-max_x,max_x),2, randf_range(-max_y,max_y))

func get_player(player_id:int) -> Player:
	for player in players:
		if player.player_id == player_id:
			return player
	return null

func game_reset():
	for player in players:
		player.respawn()
