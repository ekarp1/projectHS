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

var mousePos = Vector2(0,0)
const BULLETSPEED = 4096

func _physics_process(delta):
	if(Input.is_action_just_pressed("INTERACT")):
		mousePos = get_global_mouse_position()
		#shoot a laser from mouse
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var normalMouseVector = (mousePos - get_node("Player").position).normalized()
		var bulletNode
		bulletNode = bulletScene.instance()
		bulletNode.position = get_node("Player").position
		bulletNode.add_central_force(normalMouseVector * BULLETSPEED)
		add_child(bulletNode)