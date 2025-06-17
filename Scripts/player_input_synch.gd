extends MultiplayerSynchronizer
@onready var camera: Camera3D = $"../CamRoot/CamYaw/CamPitch/SpringArm3D/Camera3D"
@onready var player: CharacterBody3D = get_parent()
@onready var cam_mount = $"../CamRoot"
@export var horizontal_sens: float = 0.1
@export var vertical_sens: float = 0.1


#@onready var camera: Camera3D = $"../CamRoot/CamYaw/CamPitch/SpringArm3D/Camera3D"
@export var move_input : Vector2
@export var mouse_input : Vector2
@export var change_color: bool
# if we do not have input authority, don't run the process function
func _ready():
	print("Player ", get_parent().name, " authority: ", is_multiplayer_authority(), " My ID: ", multiplayer.get_unique_id())
	if is_multiplayer_authority():
		camera.make_current()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)
		#set_process_input(false)
func _physics_process (delta):
	move_input = Input.get_vector("move_right", "move_left","move_up","move_down")
	
	## Reset mouse input after each frame to prevent continuous spinning
	#if mouse_input != Vector2.ZERO:
		#mouse_input = Vector2.ZERO
func _input(event: InputEvent) -> void:
	if is_multiplayer_authority() and event is InputEventMouseMotion:
		 # Apply rotation directly here instead of storing it
		player.rotate_y(deg_to_rad(-event.relative.x * horizontal_sens))
		cam_mount.rotate_x(deg_to_rad(-event.relative.y * vertical_sens))
		
		# Clamp vertical rotation to prevent over-rotation
		cam_mount.rotation.x = clamp(cam_mount.rotation.x, deg_to_rad(-90), deg_to_rad(90))
