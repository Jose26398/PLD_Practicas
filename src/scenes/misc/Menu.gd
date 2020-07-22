extends Control


func _on_singleplayer_pressed():
	$clickSound.play()
	MenuChanger.change_scene("res://scenes/misc/Singleplayer.tscn")


func _on_multiplayer_pressed():
	$clickSound.play()
	MenuChanger.change_scene("res://scenes/misc/Multiplayer.tscn")


func _on_options_pressed():
	$clickSound.play()
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().change_scene("res://scenes/misc/Controls.tscn")


func _on_exit_pressed():
	$clickSound.play()
	get_tree().quit()

