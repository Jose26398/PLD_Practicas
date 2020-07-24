extends Control

var paused: = false setget set_paused
onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("ColorRect")
onready var save_button = $ColorRect/VBoxContainer/Save
onready var load_button = $ColorRect/VBoxContainer/Load

func _ready():
	pause_overlay.visible = false
	if not MenuChanger.singleplayer:
		$ColorRect/VBoxContainer/Save.disabled = true
		$ColorRect/VBoxContainer/Load.disabled = true
	
func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value

func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()


func _on_Resume_pressed():
	$clickSound.play()
	self.paused = not paused
	scene_tree.set_input_as_handled()


func _on_Save_pressed():
	$clickSound.play()
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_tree().get_current_scene())
	ResourceSaver.save("user://savegame.tscn", packed_scene)
	
	var stats = get_tree().get_current_scene().get_node("YSort/players/Player/PlayerStats")
	
	var save_game = File.new()
	save_game.open("user://savestats.save", File.WRITE)
	var health = {"health" : stats.health}
	var position = {"pos_x" : stats.get_parent().position.x,
					"pos_y" : stats.get_parent().position.y}
	var items = {"items" : stats.items}
	save_game.store_line(to_json(health))
	save_game.store_line(to_json(position))
	save_game.store_line(to_json(items))
	save_game.close()


func _on_Load_pressed():
	$clickSound.play()
	self.paused = not paused
	scene_tree.set_input_as_handled()
	SceneChanger.change_scene("user://savegame.tscn")
	MenuChanger.loadgame = true


func _on_Quit_pressed():
	$clickSound.play()
	MenuChanger.change_scene("res://scenes/misc/Menu.tscn")
	self.paused = not paused
	Network.end_game()
