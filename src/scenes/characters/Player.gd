extends KinematicBody2D

export (int) var speed
var motion = Vector2(0,0)

func _ready() -> void:
	set_process(true)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		motion.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		motion.y += speed * delta
	elif Input.is_action_pressed("ui_left"):
		motion.x -= speed * delta
	elif Input.is_action_pressed("ui_right"):
		motion.x += speed * delta
	else :
		motion.x = 0
		motion.y = 0
	motion = move_and_slide(motion)
	
