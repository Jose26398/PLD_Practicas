extends Area2D

class_name to_inside

"""
Add this to any area2d and it will send the player to the indicated scene and spawnpoint
"""

export(String, FILE, "*.tscn") var target_scene

onready var doorSpawn = $DoorSpawn.global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_body_entered")
	

func _on_body_entered(body):
	if body is Player and body.stats.items.has("card"):
		SceneChanger.set_health(body.get_node("PlayerStats").health)
		SceneChanger.change_scene(target_scene)
