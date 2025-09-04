# variables for script

extends Label

@onready var player: Player = $"../Player"
@onready var player_scene = preload("res://Scenes/player.tscn")

func _ready(): # connects signals and functions when script is initially called
	player.connect("player_health_changed", self.update_health)
	update_health(player.player_health)

func update_health(new_health): # updates health label from old to new health when called
	new_health = new_health
	text = "Health: %d" % new_health
