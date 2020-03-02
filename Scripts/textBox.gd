extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var optFuncArray = [null, null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func initOptions(optionArray):
	if optionArray.size() <= 4:
		for i in range(0, optionArray.size()):
			#Make the option visible
			get_node("Background/Option" + str(i + 1)).visible = true
			#Change the option text
			get_node("Background/Option" + str(i + 1)).text = optionArray[i][0]
			#Change the option's function
			if(optionArray[i][1] != null):
				optFuncArray[i] = optionArray[i][1]

func setText(textVar):
	get_node("Background/Label").text = textVar

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func opt1pressed():
	optFuncArray[0].call_func()

func opt2pressed():
	optFuncArray[1].call_func()

func opt3pressed():
	optFuncArray[2].call_func()

func opt4pressed():
	optFuncArray[3].call_func()
