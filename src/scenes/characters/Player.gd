extends KinematicBody2D

var MAX_SPEED = 700
var ACCELERATION = 5000
var motion = Vector2.ZERO

var anim = ""
var new_anim = ""
var state_machine

export(String, "U", "D", "L", "R") var facing = "D"

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	state_machine.start("Idle")

func _physics_process(delta):
	var axis = get_input_axis()
	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
	else:
		apply_movement(axis * ACCELERATION * delta)
		
	motion = move_and_slide(motion)
	
	
func get_input_axis():
	var current = state_machine.get_current_node()
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if axis.x > 0:
		new_anim = "Right"
		facing = "R"
	elif axis.x < 0:
		new_anim = "Left"
		facing = "L"
		
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if axis.y > 0:
		new_anim = "Down"
		facing = "D"
	elif axis.y < 0:
		new_anim = "Up"
		facing = "U"
		
	if axis == Vector2.ZERO:
		new_anim = "Idle"
		
	if Input.is_action_pressed("attack"):
		new_anim = "Attack" + facing
		
	## UPDATE ANIMATION
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
	
	return axis.normalized()
	
	
func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO


func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(MAX_SPEED)

	
