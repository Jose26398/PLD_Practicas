extends Control


func _on_new_game_pressed():
	MenuChanger.loadgame = false
	SceneChanger.set_spawnpoint(null)
	SceneChanger.set_health(100)
	MenuChanger.change_scene("res://scenes/levels/Scene1.tscn")


func _on_load_game_pressed():
	MenuChanger.loadgame = true
	MenuChanger.change_scene("res://config/savegame.tscn")


func _on_back_pressed():
	MenuChanger.change_scene("res://scenes/misc/Menu.tscn")
