extends KinematicBody2D

var velocity = Vector2()
# <<<<<<< HEAD
var player_speed = 300 #Max speed of the player
var player_jump_speed = 400
var player_health = 100 #The health of the payer
 #=======
# >>>>>>> ae2b437dd03b0953d5b54884ddb7805bc9d3205f
var can_walk = true #For checking if the player is moving
var jump_pressed = false

var pressedTime = 0.2 #in seconds, anti input frustration value
var coyoteTimer = 10
var jumpPressedTimer=10

var real_gravity
var real_speed
var real_jump_speed
var real_coyote_time

func _physics_process(delta):
	# TODO - Could be cool to add some sort of in game effect if the player inputs a string.
	real_gravity = float(global.gravity) if global.gravity.is_valid_float() else 0
	real_speed = float(global.player_speed) if global.player_speed.is_valid_float() else 0
	real_jump_speed = float(global.player_jump_speed) if global.player_jump_speed.is_valid_float() else 0
	real_coyote_time = float(global.player_coyote_time) if global.player_coyote_time.is_valid_float() else 0
	
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
	
	velocity.x = input_velocity * real_speed
	
	jump_pressed = false
	if Input.is_action_pressed("jump"):
		jump_pressed = true

func movement(delta):
	velocity.y += real_gravity * delta
	#please add an accel curve (i can do it if u ask) Jix
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() and jump_pressed:
		velocity.y -= real_jump_speed
	
	if jump_pressed:
		jumpPressedTimer=0
	if is_on_floor():
		coyoteTimer=0
	if coyoteTimer<=real_coyote_time and jumpPressedTimer<=pressedTime:
		velocity.y -= real_jump_speed
		jumpPressedTimer=1000
		coyoteTimer=1000
	jumpPressedTimer+=delta
	coyoteTimer+=delta

func animate():
	# TODO
	pass
