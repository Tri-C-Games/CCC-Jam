extends KinematicBody2D

var velocity = Vector2()
var player_speed = 300 #Max speed of the player
var player_jump_speed = 400
var player_health = 100 #The health of the payer
var can_walk = true #For checking if the player is moving
var jump_pressed = false
var gravity = 500 #The gravity value
var pressedTime = 0.2 #in seconds, anti input frustration value
var coyoteTime= 0.2;#in seconds
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
	
	velocity.x = input_velocity * player_speed
	
	jump_pressed = false
	if Input.is_action_pressed("jump"):
		jump_pressed = true

func movement(delta):
	velocity.y += gravity * delta
	#please add an accel curve (i can do it if u ask) Jix
	velocity = move_and_slide(velocity, Vector2.UP)
	if jump_pressed:
		jumpPressedTimer=0
	if is_on_floor():
		coyoteTimer=0
	if coyoteTimer<=coyoteTime and jumpPressedTimer<=pressedTime:
		velocity.y -= player_jump_speed
		jumpPressedTimer=1000
		coyoteTimer=1000
	jumpPressedTimer+=delta
	coyoteTimer+=delta
func animate():
	# TODO
	pass
