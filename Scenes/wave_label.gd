# sets variables for script
extends Label

@onready var enemy: EnemySpawn = $"../EnemySpawn"
@onready var enemy_scene = preload("res://Scenes/enemy_spawn.tscn")

func _ready(): # connects signals and updates wave label for inital wave
	enemy.connect("wave_won", self.update_wave)
	update_wave(enemy.wave)

func update_wave(new_wave): # updates wave label to current wave when function is called by "wave_won" signal
	new_wave = enemy.wave
	text = "Wave: %d" % new_wave
