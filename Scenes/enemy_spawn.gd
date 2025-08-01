extends Node2D

class_name EnemySpawn

signal wave_won

# configuration/way the enemies spawn
const ROWS = 2
const COLUMNS = 2
const HORIZONTAL_SPACING = 70
const VERTICAL_SPACING = 60
const ENEMY_HEIGHT = 24

var enemy_scene
const START_Y_POS = -350

const ENEMY_X_POS_INCREMENT = 15
const ENEMY_Y_POS_INCREMENT = 30
var movement_direction = 1

var enemy_shot_scene = preload("res://Scenes/enemy_shot.tscn")

@onready var player: Player = $"../Player"
@onready var player_scene = preload("res://Scenes/player.tscn")

var enemies_destroyed = 0
var enemy_total = ROWS * COLUMNS

var wave = 0

# node references
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
	
	# Pick a random initial movement direction: -1 (left) or 1 (right)
	movement_direction = [1, -1].pick_random()
	
	# Restart timers
	move_timer.start()
	shot_timer.start()
	
	# Clear previous enemies
	for child in get_children():
		if child is Enemy:
			child.queue_free()
	
	var enemy_1_res = preload("res://Resources/enemy_1.tres")
	var enemy_2_res = preload("res://Resources/enemy_2.tres")
	var enemy_3_res = preload("res://Resources/enemy_3.tres")
	
	var enemy_config
	
	for row in ROWS:
		if row == 0:
			enemy_config = enemy_1_res
		elif row == 1 or row == 2:
			enemy_config = enemy_2_res
		elif row == 3 or row == 4:
			enemy_config = enemy_3_res
		
		var row_width = (COLUMNS * enemy_config.width / 2) + ((COLUMNS - 1) * HORIZONTAL_SPACING)
		
		var start_x = position.x - row_width / 2
		
		for col in COLUMNS:
			var x = start_x + (col * enemy_config.width / 2) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POS + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_pos = Vector2(x, y)
			
			spawn_enemy(enemy_config, spawn_pos)
			enemy_total += 1



func spawn_enemy(enemy_config, spawn_pos: Vector2):
	var enemy = enemy_scene.instantiate() as Enemy
	enemy.config = enemy_config
	enemy_config = load("res://Resources/enemy_config.gd")
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
	if enemies_destroyed < enemy_total:
		# Get all enemies in the children
		var enemies = get_children().filter(func(child): return child is Enemy)
		
		# Only shoot if there are enemies present
		if enemies.size() > 0:
			# Pick a random enemy's global position
			var random_enemy = enemies.pick_random()
			var enemy_shot = enemy_shot_scene.instantiate() as EnemyShot
			enemy_shot.global_position = random_enemy.global_position
			get_tree().root.add_child(enemy_shot)
		else:
			# No enemies to shoot from, do nothing or handle accordingly
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
		await get_tree().create_timer(1.0).timeout  # Optional: delay before next wave
		spawn_wave()

func on_player_dead():
	shot_timer.stop()
	move_timer.stop()
	movement_direction = 0
