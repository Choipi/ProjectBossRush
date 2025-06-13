extends MultiplayerSynchronizer
@onready var camera: Camera3D = $"../Camera3D"
@export var move_input : Vector2
@export var change_color: bool
# if we do not have input authority, don't run the process function
func _ready():
	if is_multiplayer_authority():
		camera.make_current()
		
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_physics_process(false)

func _physics_process (delta):
	move_input = Input.get_vector("move_right", "move_left","move_up","move_down")
