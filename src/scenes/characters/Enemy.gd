extends KinematicBody2D


func enemy_die():
	print("dioshngfiud")
	var pushback_direction = (global_position).normalized()
	#move_and_slide( pushback_direction * 5000)
	$AnimationPlayer.play("Die")
		

func _on_Hurtbox_area_entered(area):
	enemy_die()
