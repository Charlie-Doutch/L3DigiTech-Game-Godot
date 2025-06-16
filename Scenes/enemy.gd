extends Area2D

class_name Enemy

var config: Resource
@onready var sprite = $Sprite2D

func _ready():
	sprite.texture = config.sprite
