# sets variables for script
extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate := 1.0  # bullets per second
@export var can_shoot = true

var time_between_shots := 1.0 / fire_rate
var last_shot_time := 0.0

func _ready(): # called when script is mentioned
	last_shot_time = -time_between_shots  # allow for immediate first shot
# sets firerate if it changes due to a powerup
func set_fire_rate(new_rate: float):
	fire_rate = new_rate
	time_between_shots = 1.0 / fire_rate

func _input(_event): # called when a programed input is pressed
	# checks to see if the input pressed is the up arrow key
	if Input.is_action_pressed("shoot") and can_shoot:
		var current_time = Time.get_ticks_msec() / 1000.0  # convert ms to seconds
		# calls shoot function when able to shoot
		if current_time - last_shot_time >= time_between_shots:
			shoot()
			last_shot_time = current_time

func shoot(): # shoots bullet
	var bullet = bullet_scene.instantiate() as Bullet # adds bullet to scene tree
	bullet.global_position = global_position - Vector2(0, 20)
	get_tree().root.get_node("main").add_child(bullet)
