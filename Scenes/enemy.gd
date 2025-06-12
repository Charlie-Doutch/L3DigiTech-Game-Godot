extends Area2D

class_name Enemy

@onready var sprite_2d = $EnemySprite

var config: Resource

func _ready():
	sprite_2d.texture = config.sprite
