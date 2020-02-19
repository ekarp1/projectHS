extends Node2D

# Preload the Walls Tilemap scene
onready var wallsScene = preload("res://Levels/0L0O/Walls.tscn")


# Declare member variables here.
enum DIRECTIONS {TOP, BOT, LEFT, RIGHT}
var doors = [["ONE", DIRECTIONS.BOT]]
const NPCTEXT = "Hello there!"
const PLAYERSIZE = Vector2(16, 16)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/World/CanvasLayer/Interface").clearInterface()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# for objType:
# 0 is NPC
# 1 is Door
func interactedWObj(objType, objIndex):
	match objType:
		0:
			match objIndex:
				0:
					# Toggle the text box if the player interacts with the first NPC
					get_node("/root/World").toggleTextBox(NPCTEXT, 3)
				1:
					# Load the arena if the player interacts with the second NPC
					get_node("/root/World").loadLevel(0, 1, 0)
		1:
			match objIndex:
				0:
					# Load the second level if the player interacts with the door
					get_node("/root/World").loadLevel(1, 0, 0, 0)

func leftObjRange(objType, objIndex):
	match objType:
		0:
			match objIndex:
				0:
					# Remove the text box if the player leaves the first npc's range
					get_node("/root/World").remTextBox()
				1:
					pass # Do nothing
		1:
			match objIndex:
				0:
					pass # Do nothing

func getDoorEntPos(doorIndex):
	match doors[doorIndex][1]:
		DIRECTIONS.TOP:
			return Vector2(get_node("DOR_" + doors[doorIndex][0]).position.x, get_node("DOR_" + doors[doorIndex][0]).position.y + PLAYERSIZE.y)
		DIRECTIONS.BOT:
			return Vector2(get_node("DOR_" + doors[doorIndex][0]).position.x, get_node("DOR_" + doors[doorIndex][0]).position.y - PLAYERSIZE.y)
		DIRECTIONS.LEFT:
			return Vector2(get_node("DOR_" + doors[doorIndex][0]).position.x - PLAYERSIZE.x, get_node("DOR_" + doors[doorIndex][0]).position.y)
		DIRECTIONS.RIGHT:
			return Vector2(get_node("DOR_" + doors[doorIndex][0]).position.x + PLAYERSIZE.x, get_node("DOR_" + doors[doorIndex][0]).position.y)
