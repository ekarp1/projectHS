extends Node2D

onready var swordScene = preload("res://Scenes/Sword.tscn")

var curSword = null
var curSwordSwungTimer = 0
var swordWaitTime = 0
var waiting = false
const PLAYERWIDTH = 145
const MAXSWORDSWINGTIME = 0.3
const MAXSWORDWAITTIME = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var mousePos = Vector2(0,0)

func _physics_process(delta):
	mousePos = get_global_mouse_position()
	# Get a normalized vector of the mouse's position relative to the player
	var normalMouseVector = (mousePos - get_node("Player").position).normalized()
	var mouseAngle = normalMouseVector.angle() + PI/2
	
	if (Input.is_action_just_pressed("FIRSTABILITY") and curSword == null and waiting == false):
		# Add the sword to the scene
		curSword = swordScene.instance()
		# Set the sword's rotation
		curSword.set_rotation(mouseAngle)
		# Move the sword to where the player is
		curSword.position = get_node("Player").position - Vector2(0, 1).rotated(mouseAngle) * PLAYERWIDTH/2
		# Set the sword to be a child of the arena
		add_child(curSword)
	elif (curSword != null):
		if (curSwordSwungTimer < MAXSWORDSWINGTIME):
			# Set the sword's rotation
			curSword.set_rotation(mouseAngle)
			# Move the sword to where the player is
			curSword.position = get_node("Player").position - Vector2(0, 1).rotated(mouseAngle) * PLAYERWIDTH/2
			# Add time to the timer for the time the sword was swung
			curSwordSwungTimer += delta
		else:
			# If the sword is done swinging, then stop using it
			curSword.queue_free()
			curSword = null
			# Then reset the timer
			curSwordSwungTimer = 0
			# And start waiting to swing again
			waiting = true
	elif(waiting == true):
		# Add time to the wait timer
		swordWaitTime += delta
		# Check if it's time to stop waiting yet
		if(swordWaitTime >= MAXSWORDWAITTIME):
			waiting = false
			swordWaitTime = 0



##--------------------------------------------------------------------------------
## Laser Code:
#
#const MAXLASERTIME = 20
#const RECHARGETIME = 0.3
#var curLaserTime = 0
#var laserPos
#var chargedTime = 0
#export var recharging = false
#
#func _process(delta):
#	# If the laser is recharging, keep waiting
#	if recharging == true:
#		chargedTime += delta
#	# If the laser is done recharging, reset the variables
#	if chargedTime >= RECHARGETIME:
#		chargedTime = 0
#		recharging = false
#		get_node("/root/World/CanvasLayer/Interface").laserStatusChanged()
#	update()

#func _physics_process(delta):
#	if(Input.is_action_just_pressed("FIRSTABILITY")):
#		mousePos = get_global_mouse_position()
#		# Check if the laser isn't recharging to see if the player can shoot or not
#		if (recharging == false):
#			#shoot a laser from mouse
#			var space_state = get_world_2d().direct_space_state
#			# use global coordinates, not local to node
#			var normalMouseVector = (mousePos - get_node("Player").position).normalized()
#			var result = space_state.intersect_ray(get_node("Player").position, normalMouseVector * 200 + get_node("Player").position, [get_node("Player")])
#			# Check if the laser hit something
#			if not result.get("position") == null:
#				laserPos = result.position
#				recharging = true
#				get_node("/root/World/CanvasLayer/Interface").laserStatusChanged()
#				update()
#				# Check if the thing the laser hit is able to take damage
#				if result.collider.has_method("take_damage"):
#					# Take damage from the laser
#					result.collider.take_damage(10)
#
#func _draw():
#	# Check if the laser exists
#	if laserPos != null:
#		# If the laser exists, then draw it
#		draw_line(get_node("Player").position, laserPos, Color(255, 0, 0), 1)
#		# Check if the laser has displayed for too long, and should be removed
#		if curLaserTime == MAXLASERTIME:
#			# Remove the laser, and reset the curLaserTime variable back to 0
#			laserPos = null
#			curLaserTime = 0
#		else:
#			# If the laser isn't done displaying, add one more to curLaserTime
#			curLaserTime = curLaserTime + 1
