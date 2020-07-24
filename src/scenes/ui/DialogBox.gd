extends Control


var dialog = [
	"",
	
	"WELCOME TO THE TUTORIAL. YOU HAVE TO GET THE KEY CARD FROM THE GUARD TO OPEN THE DOOR.",
	
	"BEHIND IT, THERE ARE THE SERGEANT AND HIS SOLDIERS, AND YOU HAVE TO DEFEAT THEM.",

	"LET'S START LEARNING SOME MOVES. DEFEAT THE NEXT SOLDIER USING \"RIGHT CLICK\" ATTACK.",
	
	"",
	
	"WELL DONE!! BUT IN SOME SITUATIONS, RUNNING IS PREFERABLE TO FIGHTING.",
	
	"USE \"LEFT CLICK\" TO DASH THROUGH THE NEXT GUARDS",
	
	"YOU WILL NOT RECEIVE DAMAGE IF YOU DO IT RIGHT AND YOU CAN RUN AWAY.",
	
	"",
	
	"NICE! NOW, HEALTH YOURSELF USING \"Q\" ON THE MEDICAL KIT (IF YOU NEED IT)",
	
	"LATER, DEFEAT BOTH SOLDIERS AND GUARD TO GET THE KEY CARD",
	
	""
]

onready var scene_tree: = get_tree()
onready var dialog_overlay: TextureRect = get_node("TextureRect")
onready var nextButton = $Button

var dialog_index = 0

func _ready():
	visible = false
	load_dialog()

func _on_Button_pressed():
	load_dialog()

func load_dialog():
	if dialog[dialog_index] != "":
		get_tree().paused = true
		visible = true
		$Dialog.bbcode_text = dialog[dialog_index]
		$Dialog.percent_visible = 0
		$Tween.interpolate_property(
			$Dialog, "percent_visible", 0, 1, 2,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		visible = false
		get_tree().paused = false
	dialog_index += 1


