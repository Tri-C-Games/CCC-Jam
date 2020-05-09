extends KinematicBody2D

var velocity = Vector2()
var can_walk = true #For checking if the player is moving
var jump_pressed = false

var pressedTime = 0.2 #in seconds, anti input frustration value
var coyoteTimer = 10
var jumpPressedTimer=10

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
	
	velocity.x = input_velocity * global.player_speed
	
	jump_pressed = false
	if Input.is_action_pressed("jump"):
		jump_pressed = true

func movement(delta):
	velocity.y += global.gravity * delta
	#please add an accel curve (i can do it if u ask) Jix
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() and jump_pressed:
		velocity.y -= global.player_jump_speed
	
	if jump_pressed:
		jumpPressedTimer=0
	if is_on_floor():
		coyoteTimer=0
	if coyoteTimer<=global.coyoteTime and jumpPressedTimer<=pressedTime:
		velocity.y -= global.player_jump_speed
		jumpPressedTimer=1000
		coyoteTimer=1000
	jumpPressedTimer+=delta
	coyoteTimer+=delta

func animate():
	# TODO
	pass
