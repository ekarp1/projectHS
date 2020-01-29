extends RigidBody2D

export var health = 100
const MAXHEALTH = 100
const HEALRATE = 1
var waitToHeal = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0):
		get_tree().change_scene("res://Scenes/firstWorld.tscn")
		#get_parent().remove_child(self)
	if (health + HEALRATE <= MAXHEALTH and waitToHeal % 20 == 19):
		health = health + HEALRATE
		waitToHeal = 0
	else:
		waitToHeal = waitToHeal + 1