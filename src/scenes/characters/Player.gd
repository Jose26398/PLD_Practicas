extends KinematicBody2D

const ACCELERATION = 4000
const MAX_SPEED = 400
const ROLL_SPEED = 120
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
#onready var swordHitbox = $player_sword/slash

func _ready():
	animationTree.active = true
	#wordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		#roll_vector = input_vector
		#swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		#animationTree.set("parameters/Attack/blend_position", input_vector)
		#animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		apply_movement(input_vector * ACCELERATION * delta)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, delta)
	else:
		animationState.travel("Idle")
		apply_friction(ACCELERATION * delta)
		velocity = velocity.move_toward(Vector2.ZERO,  delta)
	
	move()
	
	#if Input.is_action_just_pressed("roll"):
	#	state = ROLL
	
	#if Input.is_action_just_pressed("attack"):
	#	state = ATTACK


func move():
	velocity = move_and_slide(velocity)


func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO


func apply_movement(acceleration):
	velocity += acceleration
	velocity = velocity.clamped(MAX_SPEED)

