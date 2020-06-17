extends Control



func _on_singleplayer_pressed():
	MenuChanger.change_scene("res://scenes/misc/Singleplayer.tscn")


func _on_multiplayer_pressed():
	MenuChanger.change_scene("res://scenes/misc/Multiplayer.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene("res://scenes/misc/Controls.tscn")
	


func _on_exit_pressed() -> void:
	get_tree().quit()
