extends KinematicBody2D

export (int) var speed = 200


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
	velocity = move_and_slide(velocity)
