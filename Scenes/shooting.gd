extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate := 5.0  # bullets per second

var time_between_shots := 1.0 / fire_rate
var last_shot_time := 0.0

func _ready():
	last_shot_time = -time_between_shots  # allow immediate first shot

func _input(event):
	if Input.is_action_pressed("shoot"):
		var current_time = Time.get_ticks_msec() / 1000.0  # convert ms to seconds
		if current_time - last_shot_time >= time_between_shots:
			shoot()
			last_shot_time = current_time

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position - Vector2(0, 20)
	get_tree().root.get_node("main").add_child(bullet)
