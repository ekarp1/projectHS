extends Area2D

# Declare member variables here.
export (bool) var inBody = false
# for objType:
# 0 is NPC
# 1 is Door
var objType
var objIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	match get_node("..").name.right(4):
		"ONE":
			objIndex = 0
		"TWO":
			objIndex = 1
	match get_node("..").name.substr(0, 3):
		"NPC":
			objType = 0
		"DOR":
			objType = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(inBody == true):
		if get_node("/root/World").isInteractPressed():
			# Tell the level that you were interacted with
			get_node("../..").interactedWObj(objType, objIndex)
		#Only change the z index if it's an npc
		if(objType == 0):
			var playerVar = get_node("/root/World").curLevel.get_node("Player")
			#Check if the player is above or bellow
			if(playerVar.position.y < get_parent().position.y):
				get_parent().set_z_index(1)
			else:
				get_parent().set_z_index(-1)

func body_entered(body):
	if( body == get_node("/root/World/Level/Player") ):
		inBody = true

func body_exited(body):
	if( body == get_node("/root/World/Level/Player") ):
		inBody = false
		get_node("../..").leftObjRange(objType, objIndex)
