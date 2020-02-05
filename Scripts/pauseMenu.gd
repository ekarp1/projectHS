extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func toMainMenu():
	get_node("/root/World").loadLevel(get_node("/root/World").mainMenuScene)


func resumeGame():
	get_node("/root/World").togglePaused()
