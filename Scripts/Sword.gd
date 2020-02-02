extends Area2D

var swordHit = false
const SWORDDAMAGE = 10
const PLAYERLOCATION = "/root/World/Arena/Player"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func body_entered(body):
	# Check for false alarms
	if swordHit == false and body != get_node(PLAYERLOCATION):
		# Check if the body has a method called "take_damage"
		if body.has_method("take_damage"):
			# Take damage from the sword
			body.take_damage(SWORDDAMAGE)
		swordHit = true
