extends Control


var dialog = [
	"WELCOME TO THE TUTORIAL. YOU HAVE TO GET THE KEY CARD FROM THE GUARD TO OPEN THE DOOR. BEHIND IT, THERE ARE THE SERGEANT AND HIS SOLDIERS, AND YOU HAVE TO DEFEAT THEM.",

	"LET'S START LEARNING SOME MOVES. DEFEAT THE NEXT SOLDIER USING \"RIGHT CLICK\" ATTACK."
]

var dialog_index = 0
var finished = false

func _ready():
	load_dialog()


func _on_Button_pressed():
	load_dialog()


func load_dialog():
	if dialog_index < dialog.size():
		$Dialog.bbcode_text = dialog[dialog_index]
		$Dialog.percent_visible = 0
		$Tween.interpolate_property(
			$Dialog, "percent_visible", 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		queue_free()
	dialog_index += 1


