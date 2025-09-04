# class name, variables and signals for the script
extends Area2D

class_name Player

@export var player_speed = 250
@export var player_health = 3

var player_old_health = player_health
var direction = Vector2.ZERO

@onready var player_collision_rect: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var main = $"../../main"

var bound_box_x
var start_bound
var end_bound

signal player_health_changed (new_health)
signal game_over

func _ready(): # function is called when space invaders portion of game begins
	bound_box_x = player_collision_rect.shape.get_rect().size.x # sets colision box size of the player
	# sets variables for size of playing area and screen/camera
	var screen_rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	var camera_pos = camera.position
	# sets the size for the edges of the screen
	start_bound = (camera_pos.x - screen_rect.size.x)/2 - 50
	end_bound = (camera_pos.x + screen_rect.size.x)/2 +50

func _process(delta): # runs on all frames of the game, always awaiting for player input
	if main.gamestate == 1: # checks and only runs if the gamestate is in the space invaders gamestate
		# sets input variable which is set for left and right arrow keys
		var input = Input.get_axis("move_left", "move_right")
		# makes the direction of the players travel correspond with the arrow key pressed
		if input > 0:
			direction = Vector2.RIGHT
		elif input < 0:
			direction = Vector2.LEFT
		else:
			direction = Vector2.ZERO
		# sets movement speed/amount for player when moving
		var delta_movement = player_speed*delta*direction.x
		# check to see if player is attempting to move out of bounds
		if (position.x + delta_movement < start_bound + bound_box_x*transform.get_scale().x || 
			position.x + delta_movement > end_bound - bound_box_x*transform.get_scale().x):
			return
		position.x += delta_movement # moves player
		
func on_player_hit(): # handles logic for when player is hit by an enemy bullet
	# check to see if game is in space invaders gamestate, script only runs if in space invaders gamestate
	if main.gamestate == 1:
		if player_health >= 1:
			# gives player momentarily invicibilty and stops player from shooting
			player_collision_rect.call_deferred("set_disabled", true)
			player_health -= 1
			var shooting = get_node("ShootingOrigin")
			shooting.can_shoot = false
			animation_player.play("hit")
			# updates player health
			on_player_health_changed()
		if player_health == 0:
			# if player has no health left, game over
			emit_signal("game_over")
			# stops player from moving and shooting
			player_speed = 0
			var shooting = get_node("ShootingOrigin")
			shooting.can_shoot = false
			animation_player.play("destroyed")
			# updates player health
			on_player_health_changed()

func on_player_health_changed(): # function that updates player health
	# checks to see if player health displayed isn't equal to the actual player health
	if player_old_health != player_health:
			# emits signal to change player health on the health label
			emit_signal("player_health_changed", player_health)
			player_old_health = player_health

func _on_animation_player_animation_finished(anim_name): # handles logic for when animations finish
	# when player hit anaimation finishes
	if anim_name == "hit":
		# removes player invincibilty and makes them able to shoot again
		player_collision_rect.call_deferred("set_disabled", false)
		var shooting = get_node("ShootingOrigin")
		shooting.can_shoot = true
