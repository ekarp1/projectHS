extends Node2D

#Change to toggle touchscreen controls when exporting for different platforms
const ISTOUCH = false

var touchUp = false
var touchDown = false
var touchLeft = false
var touchRight = false
var touchInteract = false
var touchFirstAbility = false
var touchSecondAbility = false
var touchFirstItem = false
var touchSecondItem = false
var touchThirdItem = false
var touchBack = false



#var countInd = 0

# Preload the menu scenes
onready var mainMenuScene = preload("res://Scenes/mainscene.tscn")
onready var pauseMenuScene = preload("res://Scenes/pauseMenu.tscn")
# Preload all of the levels/arenas that will be used
onready var levelArray = [ [[preload("res://Levels/0L0O/levelScene.tscn")], [preload("res://Levels/0L0A/levelScene.tscn")]], 
	[[preload("res://Levels/1L0O/levelScene.tscn")], [preload("res://Levels/1L0A/levelScene.tscn")]] ]
# Preload the textbox scene
onready var textBoxScene = preload("res://Scenes/textBox.tscn")

signal mousePress
var mouseIsDown = false

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
	get_node("CanvasLayer/touchInput").visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isInteractPressed():
		#Remove the textbox if there still is one after two frames
		if(textBox != null):
			yield(get_tree(), "idle_frame")
			if(textBox != null):
				remTextBox()
	# Go back to the main menu if the player presses the "BACK" key
	if isBackPressed():
		#If you're not already in the main menu, then go to the main menu, otherwise just leave the game entirely
		if(curLevel.name != "mainMenu"):
			togglePaused()
	
	mouseIsDown = false
	
	#if(countInd >= 2):
#	#	countInd = 0
	#	touchInteract = false
#		touchFirstAbility = false
#		touchSecondAbility = false
#		touchFirstItem = false
#		touchSecondItem = false
#		touchThirdItem = false
#		touchBack = false
#	else:
#		countInd += delta

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton and mouseIsDown == false:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("mousePress")
			mouseIsDown = true

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
	get_node("CanvasLayer/Minimap").getMinimap()
	#Update the Gui to account for enemies in new level
	get_node("CanvasLayer/Interface").enemyHealthChanged()
	get_node("CanvasLayer/Interface").playerHealthChanged()
	#Toggle the touch input if you need to do that
	if ISTOUCH == true:
		get_node("CanvasLayer/touchInput").visible = true
	else:
		get_node("CanvasLayer/touchInput").visible = false

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










func touchUpPressed():
	touchUp = true

func touchUpReleased():
	touchUp = false

func isUpPressed():
	if Input.is_action_pressed('UP') and ISTOUCH == false:
		return true
	elif touchUp == true and ISTOUCH == true:
		return true
	else:
		return false

func touchDownPressed():
	touchDown = true

func touchDownReleased():
	touchDown = false

func isDownPressed():
	if Input.is_action_pressed('DOWN') and ISTOUCH == false:
		return true
	elif touchDown == true and ISTOUCH == true:
		return true
	else:
		return false


func touchLeftPressed():
	touchLeft = true

func touchLeftReleased():
	touchLeft = false

func isLeftPressed():
	if Input.is_action_pressed('LEFT') and ISTOUCH == false:
		return true
	elif touchLeft == true and ISTOUCH == true:
		return true
	else:
		return false

func touchRightPressed():
	touchRight = true

func touchRightReleased():
	touchRight = false

func isRightPressed():
	if Input.is_action_pressed('RIGHT') and ISTOUCH == false:
		return true
	elif touchRight == true and ISTOUCH == true:
		return true
	else:
		return false

func touchInteractPressed():
	touchInteract = true
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	touchInteract = false

func isInteractPressed():
	if Input.is_action_just_pressed('INTERACT') and ISTOUCH == false:
		return true
	elif touchInteract == true and ISTOUCH == true:
		return true
	else:
		return false

func touchFirstAbilityPressed():
	touchFirstAbility = true

func isFirstAbilityPressed():
	if Input.is_action_just_pressed('FIRSTABILITY') and ISTOUCH == false:
		return true
	elif touchFirstAbility == true and ISTOUCH == true:
		touchFirstAbility = false
		return true
	else:
		return false

func touchSecondAbilityPressed():
	touchSecondAbility = true

func isSecondAbilityPressed():
	if Input.is_action_just_pressed('SECONDABILITY') and ISTOUCH == false:
		return true
	elif touchSecondAbility == true and ISTOUCH == true:
		touchSecondAbility = false
		return true
	else:
		return false

func touchFirstItemPressed():
	touchFirstItem = true

func isFirstItemPressed():
	if Input.is_action_just_pressed('FIRSTITEM') and ISTOUCH == false:
		return true
	elif touchFirstItem == true and ISTOUCH == true:
		touchFirstItem = false
		return true
	else:
		return false

func touchSecondItemPressed():
	touchSecondItem = true

func isSecondItemPressed():
	if Input.is_action_just_pressed('SECONDITEM') and ISTOUCH == false:
		return true
	elif touchSecondItem == true and ISTOUCH == true:
		touchSecondItem = false
		return true
	else:
		return false

func touchThirdItemPressed():
	touchThirdItem = true

func isThirdItemPressed():
	if Input.is_action_just_pressed('THIRDITEM') and ISTOUCH == false:
		return true
	elif touchThirdItem == true and ISTOUCH == true:
		touchThirdItem = false
		return true
	else:
		return false

func touchBackPressed():
	touchBack = true

func isBackPressed():
	if Input.is_action_just_pressed('BACK') and ISTOUCH == false:
		return true
	elif touchBack == true and ISTOUCH == true:
		touchBack = false
		return true
	else:
		return false

