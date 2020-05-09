extends KinematicBody2D

var velocity = Vector2()
var player_speed = 300 #Max speed of the player
var player_jump_speed = 200
var player_health = 100 #The health of the payer
var can_walk = true #For checking if the player is moving
var jump_pressed = false
var gravity = 500 #The gravity value

func _physics_process(delta):
	get_input()
	movement(delta)
	animate()

func get_input():
	# Movement
	var input_velocity = 0
	if Input.is_action_pressed("move_right"):
		input_velocity += 1
	if Input.is_action_pressed("move_left"):
		input_velocity -= 1
	
	velocity.x = input_velocity * player_speed
	
	jump_pressed = false
	if Input.is_action_pressed("jump"):
		jump_pressed = true
	
	# UI
	if Input.is_action_just_pressed("open console"):
		$HUD.open_console()

func movement(delta):
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() and jump_pressed:
		velocity.y -= player_jump_speed

func animate():
	# TODO
	pass
