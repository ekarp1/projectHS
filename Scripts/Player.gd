extends KinematicBody2D

export (int) var speed = 75
export (int, 0, 75) var inertia = 100

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
var normalMouseVector = Vector2(0,0)

# Dash Variables
const DASHSPEED = 125
const DASHTIME = 2.5
const DASHCOOLDOWNTIME = 5
var dashing = false
var dashCooldown = DASHCOOLDOWNTIME
var dashingTime = 0

# Item Variables
# Variable for storing the total cooldown time
var firstItemCooldownTime = 2
# Variable for storing the time left in the cooldown
var firstItemCooldown = firstItemCooldownTime
# Variable for storing the total cooldown time
var secondItemCooldownTime = 2
# Variable for storing the time left in the cooldown
var secondItemCooldown = secondItemCooldownTime
# Variable for storing the total cooldown time
var thirdItemCooldownTime = 2
# Variable for storing the time left in the cooldown
var thirdItemCooldown = thirdItemCooldownTime

# Bomb Variables
onready var bombScene = preload("res://Scenes/Bomb.tscn")
# Wave Variables
onready var waveScene = preload("res://Scenes/Wave.tscn")
# Laser Variables
var laserPos = null
var curLaserTime = 0
const MAXLASERTIME = 10
const LASERDAMAGE = 5


# Player variables
const PLAYERWIDTH = 16

var velocity = Vector2()


func get_input():
	velocity = Vector2()
	if get_node("/root/World").isRightPressed():
		velocity.x += 1
	if get_node("/root/World").isLeftPressed():
		velocity.x -= 1
	if get_node("/root/World").isDownPressed():
		velocity.y += 1
	if get_node("/root/World").isUpPressed():
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
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider is RigidBody2D:
			collision.collider.apply_central_impulse(-collision.normal * inertia)
	
	mousePos = get_global_mouse_position()
	# Get a normalized vector of the mouse's position relative to the player
	normalMouseVector = (mousePos - position).normalized()
	# -----------------------------------------------------------------------------------------
	# Ability code
	if canUseAbilities:
		var mouseAngle = normalMouseVector.angle() - PI/2
		# -------------------------------------------------------------------------------------
		# Sword Code
		if (get_node("/root/World").isFirstAbilityPressed() and curSword == null and swordOnCooldown == false):
			# Add the sword to the scene
			curSword = swordScene.instance()
			# Set the sword's rotation
			curSword.set_rotation(mouseAngle + PI)
			# Move the sword to where the player is
			curSword.position = Vector2(0, 1).rotated(mouseAngle) * PLAYERWIDTH
			# Set the sword to be a child of the arena
			add_child(curSword)
		elif (curSword != null):
			if (curSwordSwungTimer < MAXSWORDSWINGTIME):
				# Set the sword's rotation
				curSword.set_rotation(mouseAngle + PI)
				# Move the sword to where the player is
				curSword.position = Vector2(0, 1).rotated(mouseAngle) * PLAYERWIDTH
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
		
		# -------------------------------------------------------------------------------------
		# Dash ability code
		if (get_node("/root/World").isSecondAbilityPressed() and dashing == false and dashCooldown >= DASHCOOLDOWNTIME):
			# Start dashing
			dashing = true
			dashCooldown = 0
		elif (dashing == false and dashCooldown < DASHCOOLDOWNTIME):
			# Wait until you can dash again
			dashCooldown += delta
		elif (dashing == true):
			dashingTime += delta
			# Reset the dash if you're out of time
			if (dashingTime >= DASHTIME):
				dashing = false
				dashingTime = 0
		# Dash ability code ^
		# -------------------------------------------------------------------------------------
		
		# Items code
		
		if laserPos != null:
			if curLaserTime >= MAXLASERTIME:
				laserPos = null
				curLaserTime = 0
			else: 
				curLaserTime = curLaserTime + 1
		update()
		
		# FIRST ITEM WILL BE A BOMB
		if (get_node("/root/World").isFirstItemPressed() and firstItemCooldown >= firstItemCooldownTime):
			# Execute the function for the first item
			useBomb()
			# Reset the cooldown
			firstItemCooldown = 0
		elif (firstItemCooldown < firstItemCooldownTime):
			# Wait until you can use the first item again
			firstItemCooldown += delta
		# SECOND ITEM WILL BE A LASER
		if (get_node("/root/World").isSecondItemPressed() and secondItemCooldown >= secondItemCooldownTime):
			# Execute the function for the second item
			useLaser()
			# Reset the cooldown
			secondItemCooldown = 0
		elif (secondItemCooldown < secondItemCooldownTime):
			# Wait until you can use the second item again
			secondItemCooldown += delta
		# THIRD ITEM WILL BE A WAVE
		if (get_node("/root/World").isThirdItemPressed() and thirdItemCooldown >= thirdItemCooldownTime):
			# Execute the function for the third item
			useWave()
			# Reset the cooldown
			thirdItemCooldown = 0
		elif (thirdItemCooldown < thirdItemCooldownTime):
			# Wait until you can use the third item again
			thirdItemCooldown += delta
	# Ability code ^
	# -----------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------
# ITEM FUNCTIONS

# BOMB FUNCTION
func useBomb():
	# Wait until the player clicks
	yield(get_node("/root/World"), "mousePress")
	mousePos = get_global_mouse_position()
	# Add the bomb to the scene
	var curBomb = bombScene.instance()
	# Move the sword to where the player is
	curBomb.position = mousePos
	# Set the sword to be a child of the arena
	get_parent().add_child(curBomb)
# LASER FUNCTION
func useLaser():
	# Wait until the player clicks
	yield(get_node("/root/World"), "mousePress")
	mousePos = get_global_mouse_position()
	normalMouseVector = (mousePos - position).normalized()
	#shoot a laser from mouse
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var result = space_state.intersect_ray(position, normalMouseVector * 4096 + position, [self])
	# Draw the laser somehow
	laserPos = result.position
	update()
	if result.collider != null:
		# Check if the body has a method called "take_damage"
		if result.collider.has_method("take_damage"):
			# Take damage from the sword
			result.collider.take_damage(LASERDAMAGE)
# WAVE FUNCTION
func useWave():
	# Wait until the player clicks
	yield(get_node("/root/World"), "mousePress")
	mousePos = get_global_mouse_position()
	normalMouseVector = (mousePos - position).normalized()
	# Add the wave to the scene
	var curWave = waveScene.instance()
	# Set the wave 's rotation
	var mouseAngle = normalMouseVector.angle() - PI/2
	curWave.set_rotation(mouseAngle + PI)
	# Move the wave to where the player is
	curWave.position = position
	# Change the wave's direction
	curWave.direction = normalMouseVector * 10
	# Set the wave to be a child of the arena
	get_parent().add_child(curWave)

# ITEM FUNCTIONS ^
# ---------------------------------------------------------------------------------------------


func _draw():
	if laserPos != null:
		draw_line(Vector2(0,0), laserPos - position, Color(255, 0, 0), 1)
