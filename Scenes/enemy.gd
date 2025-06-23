extends Area2D

class_name Enemy

var config: Resource
@onready var sprite = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	sprite.texture = config.sprite
	animation_player.play(config.animation_name)
