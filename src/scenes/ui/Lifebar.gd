extends Control

var hearts = 100 setget set_hearts
var max_hearts = 100 setget set_max_hearts

onready var lifeBar = $LifeBarUI

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if lifeBar != null:
		lifeBar.value = value
			
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if lifeBar != null:
		lifeBar.max_value = value

func _ready():
	self.max_hearts = get_parent().get_node("PlayerStats").max_health
	self.hearts = get_parent().get_node("PlayerStats").health
	get_parent().get_node("PlayerStats").connect("health_changed", self, "set_hearts")
	get_parent().get_node("PlayerStats").connect("max_health_changed", self, "set_max_hearts")
