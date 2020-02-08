extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var minimapWalls = null
var PLAYERWIDTH = 64
var miniMapPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update()

func _draw():
	if(minimapWalls != null and get_node("/root/World").curLevel.has_node("Player")):
		var minimapTileSize = minimapWalls.get_cell_size().x
		#Draw the player on the minimap 
		var playerPos = get_node("/root/World").curLevel.get_node("Player").get_global_position()
		#Get the top left corner of the player instead of the center
		playerPos = Vector2(playerPos.x - PLAYERWIDTH / 2, playerPos.y - PLAYERWIDTH / 2)
		#Get scale the player to match the map size
		playerPos = playerPos / (PLAYERWIDTH / minimapTileSize)
		draw_rect(Rect2(miniMapPos.x + playerPos.x, miniMapPos.y + playerPos.y, minimapTileSize, minimapTileSize), Color(1, 1, 1))

func getMinimap():
	if(minimapWalls != null):
		# Delete the minimapWalls node
		minimapWalls.queue_free()
		# Wait until the next frame so that the old minimapWalls can be completely removed
		yield(get_tree(), "idle_frame")
	minimapWalls = get_node("/root/World").curLevel.wallsScene.instance()
	# Make it so that 1 pixel in the minimap represents 1 pixel in the real world
	minimapWalls.scale = Vector2(1,1)
	# Make it so that the minimap walls can't be collided with
	minimapWalls.set_collision_layer_bit(0, 0)
	# Move the minimap to the top right corner
	miniMapPos = Vector2(get_viewport().size.x - minimapWalls.get_used_rect().size.x * minimapWalls.get_cell_size().x, 0)
	minimapWalls.position = miniMapPos
	get_child(0).set_position(miniMapPos)
	get_child(0).set_size(Vector2(minimapWalls.get_used_rect().size.x * minimapWalls.get_cell_size().x, minimapWalls.get_used_rect().size.y * minimapWalls.get_cell_size().y))
	get_child(0).visible = true
	add_child(minimapWalls)

func remMinimap():
	if(minimapWalls != null):
		# Delete the minimapWalls node
		minimapWalls.queue_free()
		# Wait until the next frame so that the old minimapWalls can be completely removed
		yield(get_tree(), "idle_frame")
		minimapWalls = null
