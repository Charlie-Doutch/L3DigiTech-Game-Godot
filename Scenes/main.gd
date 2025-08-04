extends Node

@onready var enemy: EnemySpawn = $"EnemySpawn"
@onready var enemy_scene = preload("res://Scenes/enemy_spawn.tscn")
@onready var flashcard_node = $"Flashcard"

func _ready():
	enemy.connect("wave_won", self.flashcards)
	flashcard_node.connect("flashcards_done", self.temp)
	flashcards(enemy.wave)
	flashcard_node.visible = false

func flashcards(_wave):
	print("working")

func temp():
	pass
