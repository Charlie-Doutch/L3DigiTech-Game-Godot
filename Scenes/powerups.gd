# variable for script

extends Node

@onready var enemy: EnemySpawn = $"../../EnemySpawn"
@onready var enemy_scene = preload("res://Scenes/enemy_spawn.tscn")
# connects signals and variables/nodes when script is initally called
func _ready():
	enemy.connect("wave_won", self.give_powerup)
	var shooting = get_node("../ShootingOrigin")
	var player = get_node("..")
# function to give the player a powerup
func give_powerup(_wave):
	# chooses a random number that corresponds to a powerup to give to the player
	var powerup = randi() % 3
	if powerup == 0: # player speed powerup
		var player = get_node("..")
		player.player_speed += 250
	if powerup == 1: # player health powerup
		var player = get_node("..")
		player.player_health += 2
		player.on_player_health_changed()
	if powerup == 2: # player firerate powerup
		var shooting = get_node("../ShootingOrigin")
		shooting.set_fire_rate(shooting.fire_rate + 2.0)
