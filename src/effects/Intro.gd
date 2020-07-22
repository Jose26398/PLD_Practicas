extends CanvasLayer


func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$VideoPlayer.stop()
		MenuChanger.change_scene("res://scenes/misc/Menu.tscn")
