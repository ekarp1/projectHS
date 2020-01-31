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
	# TODO: Add multiple enemies
	
	# Check if the enemy exists
	if has_node(ENEMYPARENT + "/Enemy"):
		# Change the healthbar display to show the enemy's current health
		get_node("healthbar").text = "Enemy Health: " + str(get_node(ENEMYPARENT + "/Enemy").health) + " / " + str(get_node(ENEMYPARENT + "/Enemy").MAXHEALTH)
	else:
		# Remove the healthbar if the enemy doesn't exist anymore
		get_node("healthbar").text = ""
	
	
	# Check if the Arena exists
	if has_node("/root/World/Arena"):
		# Check if the laser is recharging
		if get_node("/root/World/Arena").recharging == true:
			# Because the laser is recharging, set the UI to show the recharging dialoge
			get_node("laserstatus").text = RECHARGETEXT
		# If the laser isn't recharging, but the UI still says recharging, then remove the text from the UI
		elif get_node("laserstatus").text == RECHARGETEXT and get_node("/root/World/Arena").recharging == false:
			get_node("laserstatus").text = ""
	# If the arena doesn't exist, then get rid of the text for the laser recharging
	else:
		get_node("laserstatus").text = ""
