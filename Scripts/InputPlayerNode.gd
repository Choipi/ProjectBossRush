class_name PlayerInput extends Node

var input_dir : Vector2 = Vector2.ZERO
var jump_input := 0.0 
var run_input := false
var dash_input :=  0.0 

func _physics_process(delta):
	input_dir = Input.get_vector("move_right", "move_left", "move_up", "move_down")
	run_input = Input.is_action_pressed("run")
	dash_input = Input.is_action_just_pressed("jump")
