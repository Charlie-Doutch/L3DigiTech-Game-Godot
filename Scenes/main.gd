# variables for the script
extends Node

@export var gamestate = 0

# connects all relevant nodes that need to be referenced/controlled by the main node
@onready var enemy: EnemySpawn = $"EnemySpawn"
@onready var enemy_scene = preload("res://Scenes/enemy_spawn.tscn")
@onready var flashcard_node = $"Flashcard/Node2D"
@onready var flashcard_lists = $"Flashcard/ListSelector"
@onready var title = $"Flashcard/title"
@onready var player: Player = $"Player"
@onready var health_label = $"Health"
@onready var wave_label = $"Wave"
# calls function when game is started
func _ready():
	# connects all relevant signals and nodes
	enemy.connect("wave_won", self.flashcards)
	flashcard_node.connect("flashcards_done", self.cards_done)
	flashcard_node.connect("list_chosen", self.cards_done)
	# sets elements visibility for the start of the game
	flashcard_node.visible = true
	flashcard_lists.visible = true
	title.visible = true
	enemy.visible = false
	player.visible = false
	health_label.visible = false
	wave_label.visible = false
	# waits for vocab list to be chosen and calls the cards_done() function
	await flashcard_node.list_chosen
	cards_done()
# function called after player has cleared enemy wave, starts flashcards
func flashcards(_wave):
	# sets gamestate to 2, gamestate 2 = flashcards portion of program
	gamestate = 2
	# sets nodes visibility for flashcard portion of program
	flashcard_node.visible = true
	flashcard_lists.visible = false
	title.visible = false
	enemy.visible = false
	player.visible = false
	health_label.visible = false
	wave_label.visible = false
	# waits until all flashcards have been answered
	# once all flashcards are done, Flashcard.gd emits flashcards_done signal which then starts cards_done() function
	await flashcard_node.flashcards_done
# function called after player has done flashcards
func cards_done():
	# sets gamestate to 1, gamestate 1 = space invaders portion of program
	gamestate = 1
	# sets nodes visibility for space invaders portion of program
	flashcard_node.visible = false
	enemy.visible = true
	player.visible = true
	health_label.visible = true
	wave_label.visible = true
	# spawns enemies
	enemy.spawn_wave()
