extends Control


func _on_new_game_pressed():
	$clickSound.play()
	MenuChanger.loadgame = false
	SceneChanger.set_health(100)
	MenuChanger.change_scene("res://scenes/levels/Scene1.tscn")


func _on_load_game_pressed():
	$clickSound.play()
	MenuChanger.loadgame = true
	MenuChanger.change_scene("user://savegame.tscn")


func _on_back_pressed():
	$clickSound.play()
	MenuChanger.change_scene("res://scenes/misc/Menu.tscn")


func _ready():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(10567, 12)
	get_tree().set_network_peer(host)
