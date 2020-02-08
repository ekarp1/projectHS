extends KinematicBody2D

signal health_changed

export var health = 100
const MAXHEALTH = 100
var velocity = Vector2()
var moveTime = 2
var changeDirTime = rand_range(0.1,1)
var moveDirection = 0
var speed = 275


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Make the enemy's movement "truely" random
	randomize()

func take_damage(amount):
	health -= amount
	get_node("/root/World/CanvasLayer/Interface").enemyHealthChanged()
	# Check if the enemy's heath is all gone
	if (health <= 0):
		# Play the death sound
		get_node("/root/World/EnemyDeath").play()
		# Load the previous level
		get_node("/root/World").loadPrevLevel()

func _physics_process(delta):
	moveTime += delta
	if (moveTime >= changeDirTime):
		# Reset the move time
		moveTime = 0
		# Decide the angle to move in
		var moveAngle = rand_range(0,2*PI)
		# Convert that angle into a unit vector
		moveDirection = Vector2(cos(moveAngle), sin(moveAngle))
		# Randomize the time until changeing directions again
		changeDirTime = rand_range(0.1,1)
	# Reset the velocity
	velocity = Vector2()
	# Move in the move direction
	velocity += moveDirection * speed
	velocity = move_and_slide(velocity)

#If the player enters the damage area, then deal damage to it
#Othewise, move away from the thing that you touched
func onTouched(body):
	if(body == get_node("../Player")):
		body.take_damage(10)
		# Move in the opposite direction from the player
		moveDirection = position.direction_to(body.position).rotated(PI)
		# And also reset the moveTime and changeDirTime
		moveTime = 0
		changeDirTime = rand_range(0.1,1)
	else:
		# Rotate the direction of movement 180 degrees
		moveDirection = moveDirection.rotated(PI)
		# And also reset the moveTime and changeDirTime
		moveTime = 0
		changeDirTime = 0.1
