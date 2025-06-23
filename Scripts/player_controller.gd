class_name PlayerController extends Node

@export var _player_ref : PlayerChar
@export var _camera_input : CameraInput
@export var _player_input : PlayerInput
@export var _player_model : Node3D

const DASH_COOLDOWN = 2.0
const SPEED := 5.0
const JUMP_VELOCITY := 4.5
const ROTATION_INTERPOLATE_SPEED := 45
var can_dash:= true
var cant_move := false

func _process_jump():
	if _player_input.jump_input > 0 and _player_ref.is_on_floor():
		_player_ref.velocity.y = JUMP_VELOCITY * _player_input.jump_input

func _physics_process_controller(delta,cant_interact):
	_process_jump()
	
	var camera_basis : Basis = _camera_input.get_camera_rotation_basis()
	var camera_z := camera_basis.z
	var camera_x := camera_basis.x
	
	camera_z.y = 0
	camera_z = camera_z.normalized()
	camera_x.y = 0
	camera_x = camera_x.normalized()
	
	# NOTE: Model direction issues can be resolved by adding a negative to camera_z, depending on setup.
	var player_lookat_target = -camera_z
	
	if player_lookat_target.length() > 0.001:
		var q_from = _player_ref.orientation.basis.get_rotation_quaternion()
		var q_to = Transform3D().looking_at(player_lookat_target, Vector3.UP).basis.get_rotation_quaternion()
		
		_player_ref.orientation.basis = Basis(q_from.slerp(q_to, delta * ROTATION_INTERPOLATE_SPEED))
	else:
		# Rotates player even if standing still
		var q_from = _player_ref.orientation.basis.get_rotation_quaternion()
		var q_to = _camera_input.get_camera_base_quaternion()
		# Interpolate current rotation with desired one.
		_player_ref.orientation.basis = Basis(q_from.slerp(q_to, delta * ROTATION_INTERPOLATE_SPEED))
	
	_player_ref.orientation.origin = Vector3()
	_player_ref.orientation = _player_ref.orientation.orthonormalized()
	_player_model.global_transform.basis = _player_ref.orientation.basis
	
	# movement
	var horizontal_velocity = _player_ref.velocity
	horizontal_velocity.y = 0
	
	camera_basis = camera_basis.rotated(camera_basis.x, -camera_basis.get_euler().x)
	
	var input_dir = _player_input.input_dir
	
	if cant_interact:
		input_dir = Vector2.ZERO
	
	var direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var position_target = direction * SPEED
	
	
	
	if _player_input.dash_input and !cant_interact and can_dash  :
		position_target *= 5
		cant_move = true
		horizontal_velocity =horizontal_velocity.lerp(position_target, 100 * delta)
		if horizontal_velocity:
			_player_ref.velocity.x = horizontal_velocity.x
			_player_ref.velocity.z = horizontal_velocity.z
			_start_dash_cooldown()
			_player_ref.move_and_slide()
		await get_tree().create_timer(0.5).timeout
		cant_move = false
	elif !can_dash and _player_input.dash_input:
		_player_ref.show_dash_ui()
		
	elif _player_input.run_input and !cant_interact:
		position_target *= 1.5
	if !cant_move:
		horizontal_velocity = horizontal_velocity.lerp(position_target, 10 * delta)
	if horizontal_velocity:
		_player_ref.velocity.x = horizontal_velocity.x
		_player_ref.velocity.z = horizontal_velocity.z
	else:
		_player_ref.velocity.x = move_toward(_player_ref.velocity.x, 0, SPEED)
		_player_ref.velocity.z = move_toward(_player_ref.velocity.z, 0, SPEED)

	_player_ref.move_and_slide()

func _start_dash_cooldown():
	print(_player_ref.player_name, " dashed id is: ", _player_ref.name)
	can_dash = false
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	can_dash = true

#func show_dash_ui():
	#$"../UI/AnimPlayer".play("Cant_Dash_UI")
	
