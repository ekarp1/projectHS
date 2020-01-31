extends Node2D

# Preload the textbox scene
onready var textBoxScene = preload("res://Scenes/textBox.tscn")

# Declare member variables here.
var NPCS = ["ONE", "TWO"]
var textBox
const NPCTEXT = "Hello there!"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	for i in range(0, NPCS.size()):
		if(get_node("/root/World/Level/NPC_"  + NPCS[i] + "/InteractSquare").get("inBody") == true):
			if Input.is_action_just_pressed("INTERACT"):
				#this is where the code to start dialoge will be
				match i:
					0:
						# Toggle the text box if the player interacts with the first NPC
						if(textBox == null):
							# Show the textbox
							textBox = textBoxScene.instance()
							# Set the textbox as a child of the canvas layer so that it overlays everything else
							get_node("/root/World/CanvasLayer").add_child(textBox)
							# Change the text to say something
							textBox.get_child(0).get_child(0).text = NPCTEXT
						else:
							# Delete the text box if the player interacts with the npc twice and it still exists
							textBox.queue_free()
							textBox = null
					1:
						# Load the arena if the player interacts with the second NPC
						get_node("/root/World").loadLevel(get_node("/root/World").firstArenaScene)
		elif(i == 0 and textBox != null):
			# Delete the textbox if the player walks away
			textBox.queue_free()
			textBox = null
