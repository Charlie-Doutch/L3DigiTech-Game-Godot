extends Node

@onready var enemy: EnemySpawn = $"../../EnemySpawn"
@onready var enemy_scene = preload("res://Scenes/enemy_spawn.tscn")

func _ready():
	enemy.connect("wave_won", self.give_powerup)
	var shooting = get_node("../ShootingOrigin")
	var player = get_node("..")
	print(player.player_speed)
	print(player.player_health)
	print(shooting.fire_rate)

func give_powerup():
	var powerup = randi() % 3
	if powerup == 0:
		print(powerup)
		var player = get_node("..")
		player.player_speed += 250
		print(player.player_speed)
	if powerup == 1:
		print(powerup)
		var player = get_node("..")
		player.player_health += 2
		print(player.player_health)
	if powerup == 2:
		print(powerup)
		var shooting = get_node("../ShootingOrigin")
		shooting.fire_rate += 1.0
		print(shooting.fire_rate)
