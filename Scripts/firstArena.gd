extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bulletScene = preload("res://Scenes/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var clicked = false
var clickPos = Vector2(0,0)
const BULLETSPEED = 4096

func _physics_process(delta):
	if(clicked == true):
		#shoot a laser from mouse
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var normalClickVector = (clickPos - get_node("Player").position).normalized()
		var bulletNode
		bulletNode = bulletScene.instance()
		bulletNode.position = get_node("Player").position
		bulletNode.add_central_force(normalClickVector * BULLETSPEED)
		add_child(bulletNode)
		clicked = false

func _input(event):
	#if the user did something with a mouse button
	if event is InputEventMouseButton:
		#only capture mouse click on press, and not also on release
		if event.is_pressed() == true:
			#get the position of the mouse in the world
			clickPos = get_global_mouse_position()
			clicked = true