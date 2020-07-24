extends KinematicBody2D

const EnemyDeathEffect = preload("res://effects/EnemyDeathEffect.tscn")
const Item = preload("res://scenes/items/KeyCard.tscn")

puppet var puppet_pos = Vector2()
puppet var puppet_motion = Vector2()

const ACCELERATION = 2000
const MAX_SPEED = 400
const FRICTION = 4000


enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision

func _ready():
	animationTree.active = true
	puppet_pos = position
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null and player.is_visible():
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				animationTree.set("parameters/Idle/blend_position", direction)
				animationTree.set("parameters/Run/blend_position", direction)
				animationState.travel("Run")
			else:
				animationState.travel("Idle")
				apply_friction(ACCELERATION * delta)
				velocity = velocity.move_toward(Vector2.ZERO,  delta)
				state = IDLE
			
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 4000
	velocity = move_and_slide(velocity)


func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE


func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 50
	hurtbox.create_hit_effect()
	velocity = -velocity*1.5


sync func _no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	if stats.drop == "card":
		var item = Item.instance()
		get_parent().add_child(item)
		item.global_position = global_position
	elif stats.drop == "demo":
		var end  = get_tree().get_root().get_node("Scene2/EndLayer/End/ColorRect")
		end.visible = true
		get_tree().paused = true

