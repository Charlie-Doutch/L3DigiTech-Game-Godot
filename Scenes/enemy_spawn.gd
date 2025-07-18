extends Node2D

class_name EnemySpawn

signal enemy_destroyed(points: int)
signal wave_won
signal game_lost

# configuration/way the enemies spawn
const ROWS = 5
const COLUMNS = 11
const HORIZONTAL_SPACING = 70
const VERTICAL_SPACING = 60
const ENEMY_HEIGHT = 24

var enemy_scene
const START_Y_POS = -350

const ENEMY_X_POS_INCREMENT = 15
const ENEMY_Y_POS_INCREMENT = 30
var movement_direction = 1

var enemy_shot_scene = preload("res://Scenes/enemy_shot.tscn")

var enemies_destroyed = 0
var enemy_total = ROWS * COLUMNS

# node references
@onready var move_timer = $MoveTimer
@onready var shot_timer = $ShotTimer


func _ready():
	# set up timers
	move_timer.timeout.connect(enemy_move)
	shot_timer.timeout.connect(on_enemy_shot)
	
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
		var start_x = (position.x - row_width) / 2
		
		for col in COLUMNS:
			var x = start_x + (col * enemy_config.width / 2) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POS + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_pos = Vector2(x, y)
			
			spawn_enemy(enemy_config, spawn_pos)

func spawn_enemy(enemy_config, spawn_pos: Vector2):
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.config = enemy_config
	enemy.global_position = spawn_pos
	enemy.on_enemy_destroyed.connect(on_enemy_destroyed)
	add_child(enemy)

func enemy_move():
	position.x += ENEMY_X_POS_INCREMENT * movement_direction

func _on_left_wall_area_entered(area):
	if (movement_direction == -1):
		position.y += ENEMY_Y_POS_INCREMENT
		movement_direction *= -1


func _on_right_wall_area_entered(area):
	if (movement_direction == 1):
		position.y += ENEMY_Y_POS_INCREMENT
		movement_direction *= -1

func on_enemy_shot():
	var random_child_pos = get_children().filter(func (child ): return child is Enemy).map(func (enemy): return enemy.global_position).pick_random()
	
	var enemy_shot = enemy_shot_scene.instantiate() as EnemyShot
	enemy_shot.global_position = random_child_pos
	get_tree().root.add_child(enemy_shot)

func on_enemy_destroyed(points: int):
	enemy_destroyed.emit(points)
	enemies_destroyed += 1
	
	if enemies_destroyed == enemy_total:
		wave_won.emit()
		shot_timer.stop()
		move_timer.stop()
		movement_direction = 0
