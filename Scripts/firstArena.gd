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
		#old bullet code
		#var bulletNode
		#bulletNode = bulletScene.instance()
		#bulletNode.position = get_node("Player").position
		#bulletNode.add_central_force(normalMouseVector * BULLETSPEED)
		#add_child(bulletNode)

func _draw():
	if laserPos != null:
		draw_line(get_node("Player").position, laserPos, Color(255, 0, 0), 1)
		if curLaserTime % MAXLASERTIME == MAXLASERTIME - 1:
			laserPos = null
			curLaserTime = 0
		else: 
			curLaserTime = curLaserTime + 1