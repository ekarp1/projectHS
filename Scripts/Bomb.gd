extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const EXPLODETIME = 2
const BOMBDAMAGE = 20
const EXPLODINGTIME = 0.2
var waitTime = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	waitTime += delta
	# Check if it's time to explode
	if (waitTime >= EXPLODETIME + EXPLODINGTIME):
		# Delete self
		get_parent().remove_child(self)
	elif (waitTime >= EXPLODETIME and get_node("DamageArea/Explosion").visible == false):
		get_node("DamageArea/Explosion").visible = true
		var toDamageArray = get_node("DamageArea").get_overlapping_bodies()
		for toDamageBody in toDamageArray:
			if toDamageBody.has_method("take_damage"):
				# Take damage from the sword
				toDamageBody.take_damage(BOMBDAMAGE)

func take_damage(num):
	if num >= 5 and get_node("DamageArea/Explosion").visible == false:
		waitTime = EXPLODETIME
