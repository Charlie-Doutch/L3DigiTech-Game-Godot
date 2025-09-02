# class name and variables for script
extends Area2D

class_name EnemyShot

@export var speed = 200
@export var lifetime := 5.0

func _ready(): # creates enemy bullet when referenced
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta): # moves enemy bullet
	position.y += speed * delta

func _on_area_entered(area): # detect when bullet is in areas
	if area is Player: # if bullet is in player, player takes damage
		(area as Player).on_player_hit()
		queue_free()
