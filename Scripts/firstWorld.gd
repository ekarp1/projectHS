extends Node2D

# Preload the menu scenes
onready var mainMenuScene = preload("res://Scenes/mainscene.tscn")
onready var pauseMenuScene = preload("res://Scenes/pauseMenu.tscn")
# Preload all of the levels/arenas that will be used
onready var levelArray = [ [[preload("res://Levels/0L0O/levelScene.tscn")], [preload("res://Levels/0L0A/levelScene.tscn")]], 
	[[preload("res://Levels/1L0O/levelScene.tscn")], [preload("res://Levels/1L0A/levelScene.tscn")]] ]
# Preload the textbox scene
onready var textBoxScene = preload("res://Scenes/textBox.tscn")

var textBox
var gamePaused = false
var pauseMenuVar
var curLevel
var prevLevelIndex = [0, 0, 0]
var curLevelIndex = [0, 0, 0]

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
	if Input.is_action_just_pressed("INTERACT"):
		#Remove the textbox if there still is one after two frames
		if(textBox != null):
			yield(get_tree(), "idle_frame")
			if(textBox != null):
				remTextBox()
	# Go back to the main menu if the player presses the "BACK" key
	if Input.is_action_just_pressed("BACK"):
		#If you're not already in the main menu, then go to the main menu, otherwise just leave the game entirely
		if(curLevel.name != "mainMenu"):
			togglePaused()

func loadLevel(newLevelGroupIndex, newLevelType, newLevelIndex, doorIndex=-1):
	prevLevelIndex = curLevelIndex
	curLevelIndex = [newLevelGroupIndex, newLevelType, newLevelIndex]
	#Unpause the game if it was paused
	if gamePaused == true:
		pauseMenuVar.queue_free()
		gamePaused = false
		get_tree().paused = false
	# Delete the level node
	curLevel.queue_free()
	# Wait until the next frame so that the level and pause menu can be completely removed
	yield(get_tree(), "idle_frame")
	# Replace the old level node with the new one
	curLevel = levelArray[newLevelGroupIndex][newLevelType][newLevelIndex].instance()
	# Make the level pauseable
	curLevel.pause_mode = Node.PAUSE_MODE_STOP
	# Move the player inside the level to the door if one is specified
	if doorIndex != -1:
		curLevel.get_node("Player").position = curLevel.getDoorEntPos(doorIndex)
	add_child(curLevel)
	#Update the Gui to account for enemies in new level
	get_node("CanvasLayer/Interface").enemyHealthChanged()
	get_node("CanvasLayer/Interface").playerHealthChanged()
	get_node("CanvasLayer/Minimap").getMinimap()

func loadPrevLevel():
	loadLevel(prevLevelIndex[0], prevLevelIndex[1], prevLevelIndex[2])

func loadMainMenu():
	#Unpause the game if it was paused
	if gamePaused == true:
		pauseMenuVar.queue_free()
		gamePaused = false
		get_tree().paused = false
	# Delete the level node
	curLevel.queue_free()
	# Wait until the next frame so that the level and pause menu can be completely removed
	yield(get_tree(), "idle_frame")
	# Replace the old level node with the new one
	curLevel = mainMenuScene.instance()
	# Make the level pauseable
	curLevel.pause_mode = Node.PAUSE_MODE_STOP
	add_child(curLevel)
	#Clear the interfaces
	get_node("CanvasLayer/Interface").clearInterface()
	# Remove the old minimap if it exists
	if(get_node("CanvasLayer/Minimap").has_node("Walls")):
		get_node("CanvasLayer/Minimap").remMinimap()

func togglePaused():
	if gamePaused == false:
		get_tree().paused = true
		pauseMenuVar = pauseMenuScene.instance()
		get_node("CanvasLayer").add_child(pauseMenuVar)
		gamePaused = true
	else:
		pauseMenuVar.queue_free()
		gamePaused = false
		get_tree().paused = false
		# Wait until the next frame so that the pause menu can be completely removed
		yield(get_tree(), "idle_frame")

func percentToDb(value):
	return (value * 104/100) - 80

func toggleTextBox(textBoxText):
	if(textBox == null):
		# Show the textbox
		textBox = textBoxScene.instance()
		# Set the textbox as a child of the canvas layer so that it overlays everything else
		get_node("/root/World/CanvasLayer").add_child(textBox)
		# Change the text to say something
		textBox.get_child(0).get_child(0).text = textBoxText
	else:
		# Delete the text box if the player interacts with the npc twice and it still exists
		textBox.queue_free()
		textBox = null

func remTextBox():
	if textBox != null:
		textBox.queue_free()
		textBox = null
