# variables, class name and configs for the script
extends Area2D

class_name Enemy

var config: Resource

signal on_enemy_destroyed

@onready var sprite = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# loads the sprite for different enemies with the corresponding configuration for the enemy
func _ready():
	if config:
		sprite.texture = config.sprite_1
		animation_player.play(config.animation_name)

# detects if the enemy is in contact with the player or the players bullet
func _on_area_entered(area):
	# if enemy is in bullet, enemy plays exploding animation
	if area is Bullet:
		animation_player.play("destroyed")
		area.queue_free()
	# if enemy is in player, player takes damage
	if area is Player:
		(area as Player).on_player_hit()
		queue_free()

# clears the enemy off the screen after the animation of the enemy exploding is finished
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroyed":
		queue_free()
		emit_signal("on_enemy_destroyed")
