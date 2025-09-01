# class name, variables, signals, and constants for the script
extends Node2D

class_name EnemySpawn

# signal that emits when all enemies are killed for the wave
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

# starts the game when called
func _ready():
	# starts the game on wave 1
	wave = 1
	# starts enemy timers so they move and shoot
	move_timer.timeout.connect(enemy_move)
	shot_timer.timeout.connect(on_enemy_shot)
	# connects game over signal for when player has no health
	player.connect("game_over", self.on_player_dead)
	# connects enemies so that they can be spawned
	enemy_scene = preload("res://Scenes/enemy.tscn")

# spawns enemy wave when called
func spawn_wave():
	# resets relevant variables
	enemies_destroyed = 0
	enemy_total = 0
	# puts the enemies at the starting position
	position = Vector2(0,0)
	# makes enemies move in random direction from start position
	movement_direction = [1, -1].pick_random()
	# starts enemy timers
	move_timer.start()
	shot_timer.start()
	# clears all enemies from screen if incase there are some left over
	for child in get_children():
		if child is Enemy:
			child.queue_free()
	# loads the template/resources for the different enemy types
	var enemy_1_res = preload("res://Resources/enemy_1.tres")
	var enemy_2_res = preload("res://Resources/enemy_2.tres")
	var enemy_3_res = preload("res://Resources/enemy_3.tres")
	var enemy_config
	# sets the amount of enemy columns and rows, this tends upwards as game progresses
	var max_rows = wave + 2
	var max_columns = wave + 3
	# sets columns and rows based on the max for each
	rows = randi_range(wave, max_rows)
	columns = randi_range(wave, max_columns)
	# caps the rows and columns at a maximum amount so the game doesn't break/become impossible
	if rows > 7:
		rows = 7
	if columns > 15:
		columns = 15
	# spawns enemies in rows
	for row in range(rows):
		# sets different enemy types for different rows
		if row == 0:
			enemy_config = enemy_1_res
		elif row == 1 or row == 2:
			enemy_config = enemy_2_res
		elif row == 3 or row == 4:
			enemy_config = enemy_3_res
		# spaces enemies across row to get width for row
		var row_width = (columns * enemy_config.width / 2) + ((columns - 1) * HORIZONTAL_SPACING)
		# start pos of enemies is the halfway point of the row
		var start_x = position.x - row_width / 2
		# spawns enemies in columns
		for col in range(columns):
			# spaces and places enemies in appropriate positions with respect to the rows and the screen size
			var x = start_x + (col * enemy_config.width / 2) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POS + (row * ENEMY_HEIGHT) + (row * VERTICAL_SPACING)
			var spawn_pos = Vector2(x, y)
			# spawns enemies, increases enemy count
			# loops back until the amount of enemies spawned matches the amount based on the amount of rows and columns
			spawn_enemy(enemy_config, spawn_pos)
			enemy_total += 1
# function to spawn enemies
func spawn_enemy(enemy_config, spawn_pos: Vector2):
	# prepares enemy to be spawned
	var enemy = enemy_scene.instantiate() as Enemy
	# inital variables for enemy to spawn with
	enemy.config = enemy_config
	enemy.global_position = spawn_pos
	# connects enemy to signal that broadcasts when it is destroyed
	enemy.on_enemy_destroyed.connect(on_enemy_destroyed)
	# spawns enemy
	# adds enemy to scene tree
	add_child(enemy)
# function for enemy movement
func enemy_move():
	# enemy movement speed increases as game progresses
	position.x += (wave * 2 + enemy_x_pos_increment) * movement_direction
# if enemy hits wall, move down and change direction
func _on_left_wall_area_entered(_area):
	if (movement_direction == -1):
		position.y += enemy_y_pos_increment + wave
		movement_direction *= -1
func _on_right_wall_area_entered(_area):
	if (movement_direction == 1):
		position.y += enemy_y_pos_increment + wave
		movement_direction *= -1
# function to make enemies shoot bullets
func on_enemy_shot():
	# checks if there are enemies on screen
	if enemies_destroyed < enemy_total:
		var enemies = get_children().filter(func(child): return child is Enemy)
		if enemies.size() > 0:
			# chooses random enemy to shoot from
			var random_enemy = enemies.pick_random()
			# prepares enemy shot
			var enemy_shot = enemy_shot_scene.instantiate() as EnemyShot
			# enemy shot speed increases as game goes on
			enemy_shot.speed += wave * wave * 10
			# caps enemy shot speed so that the game doesn't become too hard/impossible
			if enemy_shot.speed > 700:
				enemy_shot.speed = 700
			# spawns the bullet on the position of the random enemy chosen
			enemy_shot.global_position = random_enemy.global_position
			get_tree().root.add_child(enemy_shot)
		else:
			pass
	else:
		pass
# function to handle logic when enemy is detroyed
func on_enemy_destroyed():
	enemies_destroyed += 1
	# detects when all enemies are destroyed
	if enemies_destroyed == enemy_total:
		wave += 1
		# emits wave won signal and stops all enemy timers
		emit_signal("wave_won", wave)
		shot_timer.stop()
		move_timer.stop()
# function to handle logic when player has no health
func on_player_dead():
	# stops all timers for enemies
	shot_timer.stop()
	move_timer.stop()
	movement_direction = 0
