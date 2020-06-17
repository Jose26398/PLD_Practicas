extends Control


func _on_join_game_pressed():
	MenuChanger.change_scene("res://scenes/levels/Scene1.tscn")


func _on_create_game_pressed():
	MenuChanger.change_scene("res://scenes/levels/Scene1.tscn")


func _on_load_game_pressed():
	MenuChanger.change_scene("res://savegame.tscn")


func _on_back_pressed():
	MenuChanger.change_scene("res://scenes/misc/Menu.tscn")
