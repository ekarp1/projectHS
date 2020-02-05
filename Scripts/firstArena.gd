extends Node2D

# Preload the Walls Tilemap scene
onready var wallsScene = preload("res://Scenes/firstArena/Walls.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Player").canUseAbilities = true
