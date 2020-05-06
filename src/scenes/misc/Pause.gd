extends Control

var paused: = false setget set_paused
onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("ColorRect")

func _ready():
	pause_overlay.visible = false

func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()

func _on_Resume_pressed():
	self.paused = not paused
	scene_tree.set_input_as_handled()


func _on_Quit_pressed():
	get_tree().quit()
