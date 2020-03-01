extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initOptions(optNum, opt1T="Option 1", opt2T="Option 2", opt3T="Option 3", opt4T="Option 4"):
	match optNum:
		1:
			get_node("Background/Option1").visible = true
			get_node("Background/Option1").text = opt1T
		2:
			get_node("Background/Option1").visible = true
			get_node("Background/Option1").text = opt1T
			get_node("Background/Option2").visible = true
			get_node("Background/Option2").text = opt2T
		3:
			get_node("Background/Option1").visible = true
			get_node("Background/Option1").text = opt1T
			get_node("Background/Option2").visible = true
			get_node("Background/Option2").text = opt2T
			get_node("Background/Option3").visible = true
			get_node("Background/Option3").text = opt3T
		4:
			get_node("Background/Option1").visible = true
			get_node("Background/Option1").text = opt1T
			get_node("Background/Option2").visible = true
			get_node("Background/Option2").text = opt2T
			get_node("Background/Option3").visible = true
			get_node("Background/Option3").text = opt3T
			get_node("Background/Option4").visible = true
			get_node("Background/Option4").text = opt4T

func setText(textVar):
	get_node("Background/Label").text = textVar

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func opt1pressed():
	pass # Replace with function body.

func opt2pressed():
	pass # Replace with function body.

func opt3pressed():
	pass # Replace with function body.

func opt4pressed():
	pass # Replace with function body.
