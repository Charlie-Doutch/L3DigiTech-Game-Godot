extends Area2D

class_name EnemyShot

@export var speed = 200
@export var lifetime := 5.0

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	position.y += speed * delta
