extends Area2D

class_name Enemy

var config: Resource

signal on_enemy_destroyed

@onready var sprite = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	sprite.texture = config.sprite_1
	animation_player.play(config.animation_name)

func _on_area_entered(area):
	if area is Bullet:
		animation_player.play("destroyed")
		area.queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroyed":
		queue_free()
		emit_signal("on_enemy_destroyed")
