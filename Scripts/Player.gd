extends KinematicBody2D

export (int) var speed = 275
export (int, 0, 275) var inertia = 100

# Set the player's max health
const MAXHEALTH = 100
# Start the player at full health
export var health = MAXHEALTH

var velocity = Vector2()


func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('RIGHT'):
		velocity.x += 1
	if Input.is_action_pressed('LEFT'):
		velocity.x -= 1
	if Input.is_action_pressed('DOWN'):
		velocity.y += 1
	if Input.is_action_pressed('UP'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	# Move the player
	velocity = move_and_slide(velocity, Vector2( 0, 0 ), false, 4, PI/4, false)
	
	# Old code that improved collisions with RigidBodies (removed because only aplicable for rigidbodys that are pushable by the player)
#	for index in get_slide_count():
#		var collision = get_slide_collision(index)
#		if collision.collider is RigidBody2D:
#			collision.collider.apply_central_impulse(-collision.normal * inertia)

func take_damage(amount):
	health -= amount
	get_node("/root/World/CanvasLayer/Interface").playerHealthChanged()
