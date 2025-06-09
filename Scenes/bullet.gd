extends Area2D

class_name Bullet

@export var bullet_speed = 300

func _process(delta):
	position.y -= delta * bullet_speed
