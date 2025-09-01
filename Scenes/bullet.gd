# variables and class name for script
extends Area2D

class_name Bullet

@export var bullet_speed = 300
@export var bullet_lifetime := 3.0

# code that creates bullet as an object when it's called
func _ready():
	await get_tree().create_timer(bullet_lifetime).timeout
	queue_free()

# code that moves the bullet after it's shot
func _process(delta):
	position.y -= delta * bullet_speed
