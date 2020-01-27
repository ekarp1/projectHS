extends Node2D

# Declare member variables here.
var NPCS = ["ONE", "TWO"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if Input.is_action_just_pressed("INTERACT"):
		for i in range(0, NPCS.size()):
			if(get_node("/root/World/Level/NPC_"  + NPCS[i] + "/InteractSquare").get("inBody") == true):
				#this is where the code to start dialoge will be
				if(i + 1 == 1):
					get_node("/root/World/CanvasLayer/textbox").visible = !get_node("/root/World/CanvasLayer/textbox").visible
				elif(i + 1 == 2):
					print("I'm different")