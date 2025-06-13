extends Node3D

@export var Speed: float



func _on_life_time_timeout() -> void:
	queue_free()
