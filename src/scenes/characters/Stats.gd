extends Node

export(int) var max_health = 100 setget set_max_health
var health = max_health setget set_health
var spawnpoint = null setget set_spawnpoint

signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal spawnpoint_changed(value)


func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)


func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func set_spawnpoint(value):
	spawnpoint = value
	emit_signal("spawnpoint_changed", spawnpoint)


func _ready():	
	self.health = max_health
	
