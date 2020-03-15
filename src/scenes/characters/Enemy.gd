extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_hurtbox_area_entered(area):
	if area.name == "player_sword":
		print("dioshngfiud")
		var pushback_direction = (global_position - area.global_position).normalized()
		move_and_slide( pushback_direction * 5000)
		$AnimationPlayer.play("Die")
