extends Node2D

# Preload the Walls Tilemap scene
onready var wallsScene = preload("res://Scenes/firstLevel/Walls.tscn")


# Declare member variables here.
var NPCS = ["ONE", "TWO"]
const NPCTEXT = "Hello there!"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/World/CanvasLayer/Interface").clearInterface()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if Input.is_action_just_pressed("INTERACT") and get_node("/root/World").textBox != null:
		get_node("/root/World").remTextBox()
	else:
		for i in range(0, NPCS.size()):
			if(get_node("/root/World/Level/NPC_"  + NPCS[i] + "/InteractSquare").get("inBody") == true):
				if Input.is_action_just_pressed("INTERACT"):
					#this is where the code to start dialoge will be
					match i:
						0:
							# Toggle the text box if the player interacts with the first NPC
							get_node("/root/World").toggleTextBox(NPCTEXT)
						1:
							# Load the arena if the player interacts with the second NPC
							get_node("/root/World").loadLevel(get_node("/root/World").firstArenaScene)
			elif(i == 0 and get_node("/root/World").textBox != null):
				if (get_node("/root/World").textBox.get_child(0).get_child(0).text == NPCTEXT):
					# Delete the textbox if the player walks away
					get_node("/root/World").remTextBox()
