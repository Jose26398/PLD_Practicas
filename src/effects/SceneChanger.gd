extends CanvasLayer

var savepoint = null setget set_savepoint
var spawnpoint = null setget set_spawnpoint
var health = 100 setget set_health

signal scene_changed()
signal spawnpoint_changed(value)
signal savepoint_changed(value)

onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func change_scene(path, delay=0.5):
	yield(get_tree().create_timer(delay), "timeout")
	animation_player.play("fade")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	animation_player.play_backwards("fade")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")


func set_spawnpoint(value):
	spawnpoint = value
	emit_signal("spawnpoint_changed", spawnpoint)


func set_savepoint(value):
	savepoint = value
	emit_signal("savepoint_changed", savepoint)


func set_health(value):
	health = value
