extends Control



func _on_new_game_pressed():
	MenuChanger.change_scene("res://scenes/levels/Scene1.tscn")


func _on_load_game_pressed():
	MenuChanger.change_scene("res://config/savegame.tscn")


func _on_back_pressed():
	MenuChanger.change_scene("res://scenes/misc/Menu.tscn")
