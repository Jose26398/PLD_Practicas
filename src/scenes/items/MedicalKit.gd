extends Sprite

const HealthEffect = preload("res://effects/HealthEffect.tscn")

func _physics_process(delta):
	if Input.is_action_just_pressed("health"):
		for body in $Area2D.get_overlapping_bodies():
			if body is Player:
				body.stats.health = body.stats.max_health
				var healthEffect = HealthEffect.instance()
				get_parent().add_child(healthEffect)
				healthEffect.global_position = body.global_position
				queue_free()
