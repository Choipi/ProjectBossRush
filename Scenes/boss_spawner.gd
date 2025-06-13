extends Area3D

@export var spawner_node: MultiplayerSpawner
@export var Boss_to_spawn: PackedScene
# Called when the node enters the scene tree for the first time.


func _on_spawning_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if is_multiplayer_authority():
			print("trying to spawn boss")
			spawn_boss(Boss_to_spawn)
			queue_free()

func spawn_boss(boss):
	var boss_node = boss.instantiate()
	boss_node.position = Vector3(10,2,10)
	spawner_node.add_child(boss_node,true)
