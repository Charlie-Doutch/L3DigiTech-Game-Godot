extends Area2D

@export var player_speed = 250
var direction = Vector2.ZERO

@onready var player_collision_rect: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bound_box_x
var start_bound
var end_bound

func _ready():
	bound_box_x = player_collision_rect.shape.get_rect().size.x
	
	var screen_rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	var camera_pos = camera.position
	
	start_bound = (camera_pos.x - screen_rect.size.x)/2
	end_bound = (camera_pos.x + screen_rect.size.x)/2

func _process(delta):
	var input = Input.get_axis("move_left", "move_right")
	
	if input > 0:
		direction = Vector2.RIGHT
	elif input < 0:
		direction = Vector2.LEFT
	else:
		direction = Vector2.ZERO
	
	var delta_movement = player_speed*delta*direction.x
	
	# Check to see if player is attempting to move out of bounds
	if (position.x + delta_movement < start_bound + bound_box_x*transform.get_scale().x || 
		position.x + delta_movement > end_bound - bound_box_x*transform.get_scale().x):
		return
	
	position.x += delta_movement
	
func on_player_hit():
	player_collision_rect.disabled = true
	animation_player.play("hit")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		player_collision_rect.disabled = false
