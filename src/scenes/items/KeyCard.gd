extends Sprite

const PickEffect = preload("res://effects/PickEffect.tscn")

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body is Player:
			body.stats.items.append("card")
			var pickEffect = PickEffect.instance()
			get_parent().add_child(pickEffect)
			pickEffect.global_position = body.global_position
			queue_free()
