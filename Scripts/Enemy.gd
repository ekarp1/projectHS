extends RigidBody2D

signal health_changed

export var health = 100
const MAXHEALTH = 100
var waitToHeal = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(amount):
	health -= amount
	get_node("/root/World/CanvasLayer/Interface").enemyHealthChanged()
	# Check if the enemy's heath is all gone
	if (health <= 0):
		# Play the death sound
		get_node("/root/World/EnemyDeath").play()
		# Leave the arena
		get_node("/root/World").loadLevel(get_node("/root/World").firstLevelScene)

