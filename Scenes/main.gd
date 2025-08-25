extends Node

@export var gamestate = 0

@onready var enemy: EnemySpawn = $"EnemySpawn"
@onready var enemy_scene = preload("res://Scenes/enemy_spawn.tscn")
@onready var flashcard_node = $"Flashcard/Node2D"
@onready var flashcard_lists = $"Flashcard/ListSelector"
@onready var player: Player = $"Player"
@onready var health_label = $"Health"
@onready var wave_label = $"Wave"

func _ready():
	enemy.connect("wave_won", self.flashcards)
	flashcard_node.connect("flashcards_done", self.cards_done)
	flashcard_node.connect("list_chosen", self.cards_done)
	
	flashcard_node.visible = true
	flashcard_lists.visible = true
	enemy.visible = false
	player.visible = false
	health_label.visible = false
	wave_label.visible = false
	
	await flashcard_node.list_chosen
	cards_done()

func flashcards(_wave):
	gamestate = 2
	flashcard_node.visible = true
	flashcard_lists.visible = false
	enemy.visible = false
	player.visible = false
	health_label.visible = false
	wave_label.visible = false
	await flashcard_node.flashcards_done

func cards_done():
	gamestate = 1
	flashcard_node.visible = false
	enemy.visible = true
	player.visible = true
	health_label.visible = true
	wave_label.visible = true
	enemy.spawn_wave()
