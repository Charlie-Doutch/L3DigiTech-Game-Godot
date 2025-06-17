extends Area2D

class_name Bullet

@export var bullet_speed = 300
@export var bullet_lifetime := 3.0

func _ready():
	await get_tree().create_timer(bullet_lifetime).timeout
	queue_free()

func _process(delta):
	position.y -= delta * bullet_speed
