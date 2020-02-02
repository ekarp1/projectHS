extends Node2D

# Preload all of the levels/arenas that will be used
onready var mainMenuScene = preload("res://Scenes/mainscene.tscn")
onready var firstLevelScene = preload("res://Scenes/firstLevel.tscn")
onready var firstArenaScene = preload("res://Scenes/firstArena.tscn")

var curLevel

# Initialize variables for sound volume
#var musicVol = 50
#var soundEffectVol = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the main menu
	curLevel = mainMenuScene.instance()
	add_child(curLevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Go back to the main menu if the player presses the "BACK" key
	if Input.is_action_just_pressed("BACK"):
		loadLevel(mainMenuScene)

func loadLevel(newLevelScene):
	# Delete the level node
	curLevel.queue_free()
	# Wait until the next frame so that the level can be completely removed
	yield(get_tree(), "idle_frame")
	# Replace the old level node with the new one
	curLevel = newLevelScene.instance()
	add_child(curLevel)
	#Update the Gui to account for enemies in new level
	get_node("CanvasLayer/Interface").enemyHealthChanged()
	get_node("CanvasLayer/Interface").playerHealthChanged()
	
	# REMOVED LASER CODE:
	#get_node("CanvasLayer/Interface").laserStatusChanged()

func percentToDb(value):
	return (value * 104/100) - 80
