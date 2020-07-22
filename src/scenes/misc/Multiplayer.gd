extends Control

func _ready():
	# Called every time the node is added to the scene.
	Network.connect("connection_failed", self, "_on_connection_failed")
	Network.connect("connection_succeeded", self, "_on_connection_success")
	Network.connect("player_list_changed", self, "refresh_lobby")
	Network.connect("game_ended", self, "_on_game_ended")
	Network.connect("game_error", self, "_on_game_error")

func _on_host_pressed():
	$clickSound.play()
	if get_node("connect/name").text == "":
		get_node("connect/error_label").text = "Invalid name!"
		return

	get_node("connect").hide()
	get_node("players").show()
	get_node("connect/error_label").text = ""

	var player_name = get_node("connect/name").text
	Network.host_game(player_name)
	refresh_lobby()

func _on_join_pressed():
	$clickSound.play()
	if get_node("connect/name").text == "":
		get_node("connect/error_label").text = "Invalid name!"
		return

	var ip = get_node("connect/ip").text
	if not ip.is_valid_ip_address():
		get_node("connect/error_label").text = "Invalid IPv4 address!"
		return

	get_node("connect/error_label").text=""
	get_node("connect/hBox/host").disabled = true
	get_node("connect/hBox/join").disabled = true

	var player_name = get_node("connect/name").text
	Network.join_game(ip, player_name)
	refresh_lobby()

func _on_connection_success():
	get_node("connect").hide()
	get_node("players").show()

func _on_connection_failed():
	get_node("connect/host").disabled = false
	get_node("connect/join").disabled = false
	get_node("connect/error_label").set_text("Connection failed.")

func _on_game_ended():
	MenuChanger.change_scene("res://scenes/misc/Menu.tscn")
	get_node("connect").show()
	get_node("players").hide()
	get_node("connect/host").disabled = false

func _on_game_error(errtxt):
	get_node("error").dialog_text = errtxt
	get_node("error").popup_centered_minsize()
	return

func refresh_lobby():
	var players = Network.get_player_list()
	players.sort()
	get_node("players/list").clear()
	get_node("players/list").add_item(Network.get_player_name() + " (You)")
	for p in players:
		get_node("players/list").add_item(p)

	get_node("players/hBox/start").disabled = not get_tree().is_network_server()


func _on_start_pressed():
	$clickSound.play()
	Network.begin_game()


func _on_back_pressed():
	$clickSound.play()
	MenuChanger.change_scene("res://scenes/misc/Menu.tscn")


func _on_back2_pressed():
	get_node("connect/hBox/host").disabled = false
	get_node("connect/hBox/join").disabled = false
	get_node("connect").show()
	get_node("players").hide()
