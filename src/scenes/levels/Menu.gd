extends Control


func _on_new_game_pressed():
	pass


func _on_load_pressed():
	pass


func _on_options_pressed() -> void:
	get_tree().change_scene("res://scenes/levels/Controls.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
