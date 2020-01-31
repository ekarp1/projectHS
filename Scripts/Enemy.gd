extends RigidBody2D

export var health = 100
const MAXHEALTH = 100
const HEALRATE = 1
const TIMEBETWEENHEALS = 20
var waitToHeal = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check if the enemy's heath is all gone
	if (health <= 0):
		# Play the death sound
		get_node("/root/World/EnemyDeath").play()
		# Leave the arena
		get_node("/root/World").loadLevel(get_node("/root/World").firstLevelScene)
		#get_parent().remove_child(self)
	# Check if the enemy can heal, and if it's time to heal yet
	if (health + HEALRATE <= MAXHEALTH and waitToHeal >= TIMEBETWEENHEALS):
		health = health + HEALRATE
		waitToHeal = 0
	# Otherwise, add 1 to the wait timer
	else:
		waitToHeal = waitToHeal + 1
