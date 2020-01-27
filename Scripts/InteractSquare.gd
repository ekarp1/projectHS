extends Area2D

# Declare member variables here.
export (bool) var inBody = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func body_entered(body):
	if( body == get_node("/root/World/Level/Player") ):
		inBody = true

func body_exited(body):
	if( body == get_node("/root/World/Level/Player") ):
		inBody = false
