extends Node2D

class_name EnemySpawn

# configuration/way the enemies spawn
const ROWS = 5
const COLUMNS = 11
const HORIZONTAL_SPACING = 30
const VERTICAL_SPACING = 20
const ENEMY_HEIGHT = 91

var enemy_scene
const START_Y_POS = -350

const ENEMY_X_POS_INCREMENT = 10
const ENEMY_Y_POS_INCREMENT = 20
var movement_direction = 1

func _ready():
	var enemy_1_res = preload("res://Resources/enemy_1.tres")
	var enemy_2_res = preload("res://Resources/enemy_2.tres")
	var enemy_3_res = preload("res://Resources/enemy_3.tres")
	enemy_scene = preload("res://Scenes/enemy.tscn")
	
	var enemy_config
	
	# sets enemies in set rows
	for row in ROWS:
		if row == 0:
			enemy_config = enemy_1_res
		elif row == 1 || row == 2:
			enemy_config = enemy_2_res
		elif row == 3 || row == 4:
			enemy_config = enemy_3_res
		
		var row_width = (COLUMNS * enemy_config.width / 2) + ((COLUMNS - 1) * HORIZONTAL_SPACING)
		var start_x = (position.x - row_width) / 2.14
		
		for col in COLUMNS:
			var x = start_x + (col * enemy_config.width / 2) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POS + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_pos = Vector2(x, y)
			
			spawn_enemy(enemy_config, spawn_pos)

func spawn_enemy(enemy_config, spawn_pos: Vector2):
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.config = enemy_config
	enemy.global_position = spawn_pos
	add_child(enemy)
