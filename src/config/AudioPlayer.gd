extends Node


func _ready():
	get_node("intro").play()


func level_start():
	get_node("intro").stop()
	get_node("soundtrack").play()
