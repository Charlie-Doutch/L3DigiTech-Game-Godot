# class name and variables for script

extends Area2D

class_name EnemyShot

@export var speed = 200
@export var lifetime := 5.0

# creates enemy bullet when referenced
func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# moves enemy bullet
func _process(delta):
	position.y += speed * delta

# detect when bullet is in areas
func _on_area_entered(area):
	# if bullet is in player, player takes damage
	if area is Player:
		(area as Player).on_player_hit()
		queue_free()
