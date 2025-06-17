extends CharacterBody3D
class_name PlayerChar

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var gravity_modifier:= 1.5
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier
var is_alive : bool = true
@export var player_name: String
var game_manager
@onready var input: MultiplayerSynchronizer = $PlayerInputSynch
var color_changed:bool = false
var cant_interact: bool = false

@export var rotation_speed : float = 8

@export var horizontal_sens: float = 0.1
@export var vertical_sens: float = 0.1

@onready var cam_mount = $CamRoot
@onready var cam_yaw = $CamRoot/CamYaw
@onready var cam_pitch = $CamRoot/CamYaw/CamPitch
#@onready var camera:= $CamRoot/CamYaw/CamPitch/Camera3D

var player_init_rotation : float

var cam_rotation : float = 0

func _enter_tree() -> void:
	$PlayerInputSynch.set_multiplayer_authority(name.to_int())


func _ready() -> void:
	#game_manager = get_tree().get_current_scene().get_node("GameManager")
	#game_manager.players.append(self)
	if multiplayer.is_server():
		position = Vector3(1,3,1)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_move(delta)
		#_handle_mouse_rotation()

#func _handle_mouse_rotation():
	## Use the synchronized mouse input from PlayerInputSynch
	#var mouse_input = input.mouse_input
	#if mouse_input != Vector2.ZERO:
		#self.rotate_y(deg_to_rad(-mouse_input.x * horizontal_sens))
		#cam_mount.rotate_x(deg_to_rad(-mouse_input.y * vertical_sens))
		## Reset mouse input after processing
		#input.mouse_input = Vector2.ZERO
#func _change_color():
	#if input.change_color:
		#color_changed = !color_changed    
		#if color_changed:
			#var temp = $Model.get_surface_override_material(0)
			#temp.albedo_color = Color.WHITE
			#$Model.set_surface_override_material(0,temp)
			#return
		#var temp = $Model.get_surface_override_material(0)
		#temp.albedo_color = Color.RED
		#$Model.set_surface_override_material(0,temp)

func _move(delta):
	#if input.mouse_input != Vector2.ZERO:
		#rotate_y(deg_to_rad(-input.mouse_input.x * horizontal_sens))
		#cam_mount.rotate_x(deg_to_rad(-input.mouse_input.y * vertical_sens))
	#
	if not is_on_floor():
		velocity.y -= gravity * delta * 25
	else:
		velocity.y = 0
	var direction = input.move_input 
	var move_dir = (transform.basis * Vector3(direction.x, 0, direction.y))
	
	if move_dir:
		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func take_damage():
	if !cant_interact:
		if multiplayer.is_server():
			cant_interact = true
			print(name, " is taking damage")
			velocity = Vector3(0,250,0)
			move_and_slide()
			await get_tree().create_timer(2).timeout
			cant_interact = false
		
