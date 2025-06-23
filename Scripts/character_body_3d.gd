extends CharacterBody3D
class_name PlayerChar

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var gravity_modifier:= 1.5
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier

@export var _player_input : PlayerInput
@export var _camera_input : CameraInput
@export var _player_model : Node3D
@export var _player_controller : PlayerController


var is_alive : bool = true
@export var player_name: String

var cant_interact: bool = false

var orientation = Transform3D()
func _enter_tree() -> void:
	_player_input.set_multiplayer_authority(str(name).to_int())
	_camera_input.set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	#game_manager = get_tree().get_current_scene().get_node("GameManager")
	#game_manager.players.append(self)
	if multiplayer.is_server():
		position = Vector3(1,3,1)


func _physics_process(delta):
	_apply_gravity(delta)
	
	if  is_multiplayer_authority():
		_player_controller._physics_process_controller(delta,cant_interact)
	else:
		# Smooths out players (model) rotation on clients
		var from = _player_model.global_transform.basis
		var to = orientation.basis.get_rotation_quaternion()
		var model_transform = Basis(from.slerp(to, delta * _player_controller.ROTATION_INTERPOLATE_SPEED))
		model_transform = model_transform.orthonormalized()
		_player_model.global_transform.basis = model_transform
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta


func take_damage():
	if !cant_interact and !_player_controller.cant_move:
		if multiplayer.is_server():
			if is_on_floor():
				cant_interact = true
				print(name, " is taking damage")
				velocity = Vector3(0,25,0)
				move_and_slide()
				await get_tree().create_timer(3.5).timeout
				cant_interact = false
		
func show_dash_ui():
	if is_multiplayer_authority():
		$UI/AnimPlayer.play("Cant_Dash_UI")
