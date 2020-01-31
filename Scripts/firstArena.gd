extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var bulletScene = preload("res://Scenes/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var mousePos = Vector2(0,0)
#const BULLETSPEED = 4096
const MAXLASERTIME = 20
const RECHARGETIME = 0.3
var curLaserTime = 0
var laserPos
var chargedTime = 0
export var recharging = false


func _process(delta):
	if recharging == true:
		chargedTime += delta
	if chargedTime >= RECHARGETIME:
		chargedTime = 0
		recharging = false
	update()

func _physics_process(delta):
	if(Input.is_action_just_pressed("FIRSTABILITY")):
		mousePos = get_global_mouse_position()
		# Check if the laser isn't recharging to see if the player can shoot or not
		if (recharging == false):
			#shoot a laser from mouse
			var space_state = get_world_2d().direct_space_state
			# use global coordinates, not local to node
			var normalMouseVector = (mousePos - get_node("Player").position).normalized()
			var result = space_state.intersect_ray(get_node("Player").position, normalMouseVector * 4096 + get_node("Player").position, [get_node("Player")])
			laserPos = result.position
			recharging = true
			update()
			if result.collider != null:
				if not result.collider.get("health") == null:
					result.collider.health = result.collider.health - 10

func _draw():
	# Check if the laser exists
	if laserPos != null:
		# If the laser exists, then draw it
		draw_line(get_node("Player").position, laserPos, Color(255, 0, 0), 1)
		# Check if the laser has displayed for too long, and should be removed
		if curLaserTime == MAXLASERTIME:
			# Remove the laser, and reset the curLaserTime variable back to 0
			laserPos = null
			curLaserTime = 0
		else:
			# If the laser isn't done displaying, add one more to curLaserTime
			curLaserTime = curLaserTime + 1
