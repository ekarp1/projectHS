extends KinematicBody2D

export (int) var speed = 275
export (int, 0, 275) var inertia = 100

# Set the player's max health
const MAXHEALTH = 100
# Start the player at full health
export var health = MAXHEALTH
# Whether or not the player can use its abilities
var canUseAbilities = false


# Sword Variables
onready var swordScene = preload("res://Scenes/Sword.tscn")
var curSword = null
var curSwordSwungTimer = 0
var swordCooldown = 0
var swordOnCooldown = false
const MAXSWORDSWINGTIME = 0.3
const SWORDCOOLDOWNTIME = 0.5
var mousePos = Vector2(0,0)

# Dash Variables
const DASHSPEED = 500
const DASHTIME = 2.5
const DASHCOOLDOWNTIME = 5
var dashing = false
var dashCooldown = DASHCOOLDOWNTIME
var dashingTime = 0

# Player variables
const PLAYERWIDTH = 145

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
	# Change the speed depending on whether or not the character is dashing
	if dashing == false:
		velocity = velocity.normalized() * speed
	else:
		velocity = velocity.normalized() * DASHSPEED

func _physics_process(delta):
	get_input()
	# Move the player
	velocity = move_and_slide(velocity, Vector2( 0, 0 ), false, 4, PI/4, false)
	
	mousePos = get_global_mouse_position()
	# Get a normalized vector of the mouse's position relative to the player
	var normalMouseVector = (mousePos - position).normalized()
	
	if canUseAbilities:
		var mouseAngle = normalMouseVector.angle() - PI/2
		# -------------------------------------------------------------------------------------
		# Sword Code
		if (Input.is_action_just_pressed("FIRSTABILITY") and curSword == null and swordOnCooldown == false):
			# Add the sword to the scene
			curSword = swordScene.instance()
			# Set the sword's rotation
			curSword.set_rotation(mouseAngle + PI)
			# Move the sword to where the player is
			curSword.position = Vector2(0, 1).rotated(mouseAngle) * PLAYERWIDTH/2
			# Set the sword to be a child of the arena
			add_child(curSword)
		elif (curSword != null):
			if (curSwordSwungTimer < MAXSWORDSWINGTIME):
				# Set the sword's rotation
				curSword.set_rotation(mouseAngle + PI)
				# Move the sword to where the player is
				curSword.position = Vector2(0, 1).rotated(mouseAngle) * PLAYERWIDTH/2
				# Add time to the timer for the time the sword was swung
				curSwordSwungTimer += delta
			else:
				# If the sword is done swinging, then stop using it
				curSword.queue_free()
				curSword = null
				# Then reset the timer
				curSwordSwungTimer = 0
				# And start waiting to swing again
				swordOnCooldown = true
		elif (swordOnCooldown == true):
			# Add time to the wait timer
			swordCooldown += delta
			# Check if it's time to stop waiting yet
			if(swordCooldown >= SWORDCOOLDOWNTIME):
				swordOnCooldown = false
				swordCooldown = 0
		# Sword Code ^
		# -------------------------------------------------------------------------------------
		
		# Dash ability code
		if (Input.is_action_just_pressed("SECONDABILITY") and dashing == false and dashCooldown >= DASHCOOLDOWNTIME):
			dashing = true
			dashCooldown = 0
		elif (dashing == false and dashCooldown < DASHCOOLDOWNTIME):
			dashCooldown += delta
		elif (dashing == true):
			dashingTime += delta
			# Reset the dash if you're out of time
			if (dashingTime >= DASHTIME):
				dashing = false
				dashingTime = 0

func take_damage(amount):
	if(health - amount > 0):
		health -= amount
		get_node("/root/World/CanvasLayer/Interface").playerHealthChanged()
	else:
		health = MAXHEALTH
		# Play the death noise
		get_node("/root/World/PlayerDeath").play()
		# Create a textbox with "you died" text
		get_node("/root/World").remTextBox()
		get_node("/root/World").toggleTextBox("You died")
		# Load the previous level
		get_node("/root/World").loadPrevLevel()
