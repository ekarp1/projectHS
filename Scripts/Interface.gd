extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ARENALOCATION = "/root/World/Arena"

# Laser Related Code:
#const RECHARGETEXT = "Recharging Laser..."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func enemyHealthChanged():
	# TODO: Account for multiple enemies
	# Check if the enemy exists
	if has_node(ARENALOCATION + "/Enemy"):
		# Change the enemy health bar display to show the enemy's current health
		get_node("UICont/enemyhealth").text = "Enemy Health: " + str(get_node(ARENALOCATION + "/Enemy").health) + " / " + str(get_node(ARENALOCATION + "/Enemy").MAXHEALTH)
	else:
		# Remove the enemy health bar if the enemy doesn't exist anymore
		get_node("UICont/enemyhealth").text = ""

func playerHealthChanged():
	# Check if the player exists
	if has_node(ARENALOCATION + "/Player"):
		# Change the player health bar display to show the player's current health
		get_node("UICont/playerhealth").text = "Player Health: " + str(get_node(ARENALOCATION + "/Player").health) + " / " + str(get_node(ARENALOCATION + "/Player").MAXHEALTH)
	else:
		# Remove the player health bar if the player doesn't exist anymore
		get_node("UICont/playerhealth").text = ""

## Laser related code:
#func laserStatusChanged():
#	# Check if the Arena exists
#	if has_node("/root/World/Arena"):
#		# Check if the laser is recharging
#		if get_node("/root/World/Arena").recharging == true:
#			# Because the laser is recharging, set the UI to show the recharging dialoge
#			get_node("UICont/laserstatus").text = RECHARGETEXT
#		# If the laser isn't recharging, but the UI still says recharging, then remove the text from the UI
#		elif get_node("UICont/laserstatus").text == RECHARGETEXT and get_node("/root/World/Arena").recharging == false:
#			get_node("UICont/laserstatus").text = ""
#	# If the arena doesn't exist, then get rid of the text for the laser recharging
#	else:
#		get_node("UICont/laserstatus").text = ""
