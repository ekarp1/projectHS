extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction
var speed = 100
const WAVEDAMAGE = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	apply_central_impulse(direction * speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func waveCollided(body):
	if body.has_method("take_damage"):
		body.take_damage(WAVEDAMAGE)
	self.queue_free()
