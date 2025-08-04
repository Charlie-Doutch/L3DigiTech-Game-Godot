extends Node2D

class_name EnemySpawn

signal wave_won

var rows = 0
var columns = 0
const HORIZONTAL_SPACING = 70
const VERTICAL_SPACING = 60
const ENEMY_HEIGHT = 24

var enemy_scene
const START_Y_POS = -350

var enemy_x_pos_increment = 10
var enemy_y_pos_increment = 28
var movement_direction = 1

var enemy_shot_scene = preload("res://Scenes/enemy_shot.tscn")

@onready var player: Player = $"../Player"
@onready var player_scene = preload("res://Scenes/player.tscn")

var enemies_destroyed = 0
var enemy_total = rows * columns

var wave = 0

@onready var move_timer = $MoveTimer
@onready var shot_timer = $ShotTimer

func _ready():
	wave = 1
	move_timer.timeout.connect(enemy_move)
	shot_timer.timeout.connect(on_enemy_shot)
	player.connect("game_over", self.on_player_dead)
	enemy_scene = preload("res://Scenes/enemy.tscn")
	spawn_wave()

func spawn_wave():
	enemies_destroyed = 0
	enemy_total = 0
	position = Vector2(0,0)

	movement_direction = [1, -1].pick_random()

	move_timer.start()
	shot_timer.start()

	for child in get_children():
		if child is Enemy:
			child.queue_free()
	
	var enemy_1_res = preload("res://Resources/enemy_1.tres")
	var enemy_2_res = preload("res://Resources/enemy_2.tres")
	var enemy_3_res = preload("res://Resources/enemy_3.tres")
	
	var enemy_config
	
	var max_rows = wave + 2
	var max_columns = wave + 3
	
	rows = randi_range(wave, max_rows)
	columns = randi_range(wave, max_columns)
	
	if rows > 7:
		rows = 7
	if columns > 15:
		columns = 15
	
	for row in range(rows):
		if row == 0:
			enemy_config = enemy_1_res
		elif row == 1 or row == 2:
			enemy_config = enemy_2_res
		elif row == 3 or row == 4:
			enemy_config = enemy_3_res
		
		var row_width = (columns * enemy_config.width / 2) + ((columns - 1) * HORIZONTAL_SPACING)
		
		var start_x = position.x - row_width / 2
		
		for col in range(columns):
			var x = start_x + (col * enemy_config.width / 2) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POS + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_pos = Vector2(x, y)
			
			spawn_enemy(enemy_config, spawn_pos)
			enemy_total += 1



func spawn_enemy(enemy_config, spawn_pos: Vector2):
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.config = enemy_config
	enemy.global_position = spawn_pos
	enemy.on_enemy_destroyed.connect(on_enemy_destroyed)
	add_child(enemy)

func enemy_move():
	position.x += (wave * 2 + enemy_x_pos_increment) * movement_direction

func _on_left_wall_area_entered(_area):
	if (movement_direction == -1):
		position.y += enemy_y_pos_increment + wave
		movement_direction *= -1


func _on_right_wall_area_entered(_area):
	if (movement_direction == 1):
		position.y += enemy_y_pos_increment + wave
		movement_direction *= -1

func on_enemy_shot():
	if enemies_destroyed < enemy_total:
		var enemies = get_children().filter(func(child): return child is Enemy)
		if enemies.size() > 0:
			var random_enemy = enemies.pick_random()
			var enemy_shot = enemy_shot_scene.instantiate() as EnemyShot
			enemy_shot.speed += wave * wave * 10
			if enemy_shot.speed > 700:
				enemy_shot.speed = 700
			enemy_shot.global_position = random_enemy.global_position
			get_tree().root.add_child(enemy_shot)
		else:
			pass
	else:
		pass

func on_enemy_destroyed():
	enemies_destroyed += 1
	print("Enemy destroyed: %d / %d" % [enemies_destroyed, enemy_total])
	if enemies_destroyed == enemy_total:
		wave += 1
		emit_signal("wave_won", wave)
		shot_timer.stop()
		move_timer.stop()
		await get_tree().create_timer(1.0).timeout
		spawn_wave()

func on_player_dead():
	shot_timer.stop()
	move_timer.stop()
	movement_direction = 0
