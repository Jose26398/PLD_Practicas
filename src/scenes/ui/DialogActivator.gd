extends Area2D


func _on_dialogActivator_body_entered(body):
	if body is Player:
		var dialog  = get_tree().get_root().get_node("Scene1/DialogLayer/DialogBox")
		dialog.load_dialog()
		queue_free()
