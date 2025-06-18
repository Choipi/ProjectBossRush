class_name DashModule extends Node
@export var _player_ref : PlayerChar
@export var _player_input : PlayerInput
@export var _camera_input : CameraInput
@export var _player_model : Node3D
@export var _player_controller : PlayerController

const DASH_VELOCITY := 6.0

var dash_available := true

func process_dash(delta):
	var camera_basis : Basis = _camera_input.get_camera_rotation_basis()
	var camera_z := camera_basis.z
	
	camera_z.y = 0
	camera_z = camera_z.normalized()
	
	# NOTE: Model direction issues can be resolved by adding a negative to camera_z, depending on setup.
	var player_lookat_target = -camera_z
	if _player_input.dash_input > 0 and dash_available:
		_player_ref.velocity = Vector3()
	
	
