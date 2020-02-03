extends Control

var can_change_key = false
var action_string
enum ACTIONS {UP, DOWN, LEFT, RIGHT, INTERACT, FIRSTABILITY, SECONDABILITY, BACK}
var fullscreen = false

func _ready():
	_set_keys()  
  
func _set_keys():
	for j in ACTIONS:
		get_node("Panel/ScrollContainer/VBoxContainer/HBoxCont_" + str(j) + "/Button").set_pressed(false)
		if !InputMap.get_action_list(j).empty():
			var buttonString
			if (InputMap.get_action_list(j)[0] is InputEventMouseButton):
				buttonString = "Mouse Button " + str(InputMap.get_action_list(j)[0].get_button_index())
			else:
				buttonString = InputMap.get_action_list(j)[0].as_text()
			get_node("Panel/ScrollContainer/VBoxContainer/HBoxCont_" + str(j) + "/Button").set_text(buttonString)
		else:
			get_node("Panel/ScrollContainer/VBoxContainer/HBoxCont_" + str(j) + "/Button").set_text("No Button!")

# -------------------------------------------------------------------------------------
# Change keybind functions

func b_change_key_UP():
	_mark_button("UP")

func b_change_key_DOWN():
	_mark_button("DOWN")

func b_change_key_LEFT():
	_mark_button("LEFT")

func b_change_key_RIGHT():
	_mark_button("RIGHT")

func b_change_key_INTERACT():
	_mark_button("INTERACT")

func b_change_key_FIRSTABILITY():
	_mark_button("FIRSTABILITY")

func b_change_key_SECONDABILITY():
	_mark_button("SECONDABILITY")

func b_change_key_BACK():
	_mark_button("BACK")

# Change keybind functions ^
# -------------------------------------------------------------------------------------

func _mark_button(string):
	can_change_key = true
	action_string = string
	
	for j in ACTIONS:
		if j != string:
			get_node("Panel/ScrollContainer/VBoxContainer/HBoxCont_" + str(j) + "/Button").set_pressed(false)

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton or (event is InputEventMouseButton and event.get_button_index() >= 1 and event.get_button_index() <= 3): 
	
		if can_change_key:
			_change_key(event)
			can_change_key = false
			

func _change_key(new_key):
	#Delete key of pressed button
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	
	#Check if new key was assigned somewhere
	for i in ACTIONS:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
	
	#Add new Key
	InputMap.action_add_event(action_string, new_key)
	
	_set_keys()

# -------------------------------------------------------------------------------------
# Volume and Sound Settings

func mainVolChanged(value):
	# Set the volume throughout the entire game
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), get_node("/root/World").percentToDb(value))


func musicVolChanged(value):
	# get_node("/root/World").musicVol = get_node("/root/World").percentToDb(value)
	# Change the music to the right volume
	get_node("/root/World/Music").volume_db = get_node("/root/World").percentToDb(value)


func soundEffectVolChanged(value):
	# get_node("/root/World").soundEffectVol = get_node("/root/World").percentToDb(value)
	# Change the death sound to the right volume
	get_node("/root/World/EnemyDeath").volume_db = get_node("/root/World").percentToDb(value)
	get_node("/root/World/PlayerDeath").volume_db = get_node("/root/World").percentToDb(value)

# Volume and Sound Settings ^
# -------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------
# Load and save settings

var save_path = "res://settings.cfg"
var config = ConfigFile.new()
var load_response = config.load(save_path)

func saveSettings():
	# Save all of the controls
	for j in ACTIONS:
		config.set_value("Controls", str(j), InputMap.get_action_list(j)[0])
	# Save the fullscreen state
	config.set_value("Video", "Fullscreen", fullscreen)
	config.save(save_path)

func loadSettings():
	# Load all of the controls
	for j in ACTIONS:
		#Delete key of button
		if !InputMap.get_action_list(j).empty():
			InputMap.action_erase_event(j, InputMap.get_action_list(j)[0])
		#Add new Key
		InputMap.action_add_event( j, config.get_value("Controls", str(j), j) )
	_set_keys()
	
	# Load the fullscreen state
	fullscreen = config.get_value("Video", "Fullscreen", fullscreen)
	OS.window_fullscreen = fullscreen

# Load and save settings ^
# -------------------------------------------------------------------------------------

func startGame():
	# Load the starting level
	get_node("/root/World").loadLevel(get_node("/root/World").firstLevelScene)

func fullscreenToggle():
	fullscreen = !OS.window_fullscreen
	OS.window_fullscreen = fullscreen

func quitGame():
	 get_tree().quit()
