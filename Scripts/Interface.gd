extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ENEMYPARENT = "/root/World/Arena"
const RECHARGETEXT = "Recharging Laser..."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_node(ENEMYPARENT + "/Enemy"):
		get_node("healthbar").text = "Enemy Health: " + str(get_node(ENEMYPARENT + "/Enemy").health) + " / " + str(get_node(ENEMYPARENT + "/Enemy").MAXHEALTH)
	else:
		get_node("healthbar").text = ""
	if has_node("/root/World/Arena"):
		if get_node("/root/World/Arena").recharging == true:
			get_node("laserstatus").text = RECHARGETEXT
		elif get_node("laserstatus").text == RECHARGETEXT and get_node("/root/World/Arena").recharging == false:
			get_node("laserstatus").text = ""
	else:
		get_node("laserstatus").text = ""