# resources, class name, and variables for the enemies 
# enemies take resources from this script and apply the variables the each enemy accordingly
extends Resource

class_name EnemyResource

@export var sprite_1: Texture2D
@export var sprite_2: Texture2D
@export var width: int
@export var animation_name: String
@export var points: int
