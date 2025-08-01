extends Label

@onready var enemy: EnemySpawn = $"../EnemySpawn"
@onready var enemy_scene = preload("res://Scenes/enemy_spawn.tscn")

func _ready():
	enemy.connect("wave_won", self.update_wave)
	update_wave(enemy.wave)

func update_wave(new_wave):
	new_wave = enemy.wave
	text = "Wave: %d" % new_wave
