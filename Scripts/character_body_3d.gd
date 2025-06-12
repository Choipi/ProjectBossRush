extends CharacterBody3D
class_name PlayerChar

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var gravity_modifier:= 1.5
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier
@onready var camera: Camera3D = $Camera3D
var is_alive : bool = true
@export var player_name: String
var game_manager
var move_input: Vector2
@onready var input: MultiplayerSynchronizer = $PlayerInputSynch


func _enter_tree() -> void:
	$PlayerInputSynch.set_multiplayer_authority(name.to_int())

func _ready() -> void:
	#game_manager = get_tree().get_current_scene().get_node("GameManager")
	#game_manager.players.append(self)
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		pass #camera.make_current()
	if multiplayer.is_server():
		position = Vector3(1,3,1)


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_move(delta)


func _move(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
	var direction = input.move_input 
	#var move_dir = (transform.basis * Vector3(move_input.x, 0, move_input.y))
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
