extends KinematicBody2D

class_name Player

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()
puppet var puppet_anim = MOVE

const ACCELERATION = 4000
const MAX_SPEED = 600
const ATTACK_SPEED = 500
const ROLL_SPEED = 900
const FRICTION = 300

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

onready var stats = $PlayerStats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $Position2D/SwordHitbox
onready var hurtbox = $Hurtbox
onready var camera = $Camera2D
onready var softCollision = $SoftCollision
onready var dead_overlay: ColorRect = get_node("DeadLayer/ColorRect")


func _ready():
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	AudioPlayer.get_node("intro").stop()
	get_node("Sounds/soundtrack").play()
	
	if MenuChanger.loadgame:
		var savestats = File.new()
		savestats.open("user://savestats.save", File.READ)
		var health = parse_json(savestats.get_line()).values()[0]
		var posicion = parse_json(savestats.get_line())
		var items = parse_json(savestats.get_line()).values()[0]
		
		stats.set_health( health )
		position = Vector2(posicion["pos_x"], posicion["pos_y"])
		stats.items = items
		savestats.close()
		
		MenuChanger.loadgame = false
	
	else:
		if not SceneChanger.health == 0:
			stats.set_health(SceneChanger.health)
			
	if is_network_master():
		camera.make_current()
		
	puppet_pos = position


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)


func move_state(delta):
	var input_vector = Vector2.ZERO
	if is_network_master():
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		
		rset_unreliable("puppet_pos", position)
		rset_unreliable("puppet_motion", input_vector)
		rset_unreliable("puppet_anim", MOVE)
	else:
		position = puppet_pos
		input_vector = puppet_motion
	move(delta)
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		apply_movement(input_vector * ACCELERATION * delta)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, delta)
	else:
		animationState.travel("Idle")
		apply_friction(ACCELERATION * delta)
		velocity = velocity.move_toward(Vector2.ZERO,  delta)
	
	if not MenuChanger.singleplayer:
		if not is_network_master() and puppet_anim == MOVE:
			if puppet_motion != Vector2.ZERO:
				animationState.travel("Run")
			else:
				animationState.travel("Idle")
		if not is_network_master() and puppet_anim == ROLL:
			animationState.travel("Roll")
		if not is_network_master() and puppet_anim == ATTACK:
			animationState.travel("Attack")
	
	
		# puppet
		if !is_network_master():
			position = puppet_pos
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func roll_state(delta):
	$Hurtbox/CollisionShape2D.disabled = true
	if is_network_master():
		velocity = roll_vector * ROLL_SPEED
		rset_unreliable("puppet_pos", position)
		rset_unreliable("puppet_motion", velocity)
		rset_unreliable("puppet_anim", ROLL)
		animationState.travel("Roll")
	else:
		position = puppet_pos
		velocity = puppet_motion
		state = puppet_anim
	move(delta)


func attack_state(delta):
	var input_vector = Vector2.ZERO
	if is_network_master():
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		input_vector = input_vector.normalized()
		velocity = velocity.move_toward(input_vector * ATTACK_SPEED, delta)
		rset_unreliable("puppet_pos", position)
		rset_unreliable("puppet_motion", input_vector)
		rset_unreliable("puppet_anim", ATTACK)
		animationState.travel("Attack")
	else:
		position = puppet_pos
		velocity = puppet_motion
		state = puppet_anim
	move(delta)


func move(delta):
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 4000
	velocity = move_and_slide(velocity)


func roll_animation_finished():
	$Hurtbox/CollisionShape2D.disabled = false
	$Sounds/dashSound.play()
	velocity = velocity * 0.8
	state = MOVE
	if not MenuChanger.singleplayer:
		if is_network_master():
			rset_unreliable("puppet_anim", MOVE)


func attack_animation_finished():
	state = MOVE
	if not MenuChanger.singleplayer:
		if is_network_master():
			rset_unreliable("puppet_anim", MOVE)


func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO


func apply_movement(acceleration):
	velocity += acceleration
	velocity = velocity.clamped(MAX_SPEED)


func _on_Hurtbox_area_entered(area):
	$Sounds/enemyAttack.play()
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	stats.health -= area.damage


func set_player_name(new_name):
	get_node("Label").set_text(new_name)


sync func _no_health():
	$Sounds/deathSound.play()
	hide()
	set_physics_process(false)
	set_process(false)
	remove_child(hurtbox)
	if is_network_master():
		dead_overlay.visible = true
