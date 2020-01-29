extends Node2D

# Preload all of the levels/arenas that will be used
onready var firstLevelScene = preload("res://Scenes/firstLevel.tscn")
onready var firstArenaScene = preload("res://Scenes/firstArena.tscn")

var curLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load the starting level
	curLevel = firstLevelScene.instance()
	add_child(curLevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("BACK"):
		get_tree().change_scene("res://Scenes/mainscene.tscn")

# TODO: Create a function for changing the level/arena
func loadLevel(newLevelScene):
	# Delete the level node
	curLevel.queue_free()
	# Replace the old level node with the new one
	curLevel = newLevelScene.instance()
	add_child(curLevel)