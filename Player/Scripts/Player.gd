extends KinematicBody2D

var velocity = Vector2()
var can_walk = true #For checking if the player is moving
var jump_pressed = false

export (Curve) var acc_curve
export (Curve) var friction_curve

var coyoteTime= 0.2;#in seconds
var pressedTime = 0.2 #in seconds, anti input frustration value
var coyoteTimer = 10
var jumpPressedTimer=10

var real_gravity
var real_jump_speed
var real_max_speed
var real_max_acc
var real_max_friction

func _physics_process(delta):
	# TODO - Could be cool to add some sort of in game effect if the player inputs a string.
	real_gravity = float(global.gravity) if global.gravity.is_valid_float() else 0.0
	real_jump_speed = float(global.player_jump_speed) if global.player_jump_speed.is_valid_float() else 0.0
	real_max_speed = float(global.player_max_speed) if global.player_max_speed.is_valid_float() else 0.0
	real_max_acc = float(global.player_max_acc) if global.player_max_acc.is_valid_float() else 0.0
	real_max_friction = float(global.player_max_friction) if global.player_max_friction.is_valid_float() else 0.0
	
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
	
	var normalized_speed = range_lerp(velocity.x, 0, real_max_speed, 0, 1)
	var acc = acc_curve.interpolate(abs(normalized_speed)) * real_max_acc
	velocity.x += input_velocity * acc
	
	jump_pressed = false
	if Input.is_action_pressed("jump"):
		jump_pressed = true

func movement(delta):
	if not is_on_floor():
		velocity.y += real_gravity * delta
	
	# Friction
	var normalized_speed = range_lerp(velocity.x, 0, real_max_speed, 0, 1)
	var friction = friction_curve.interpolate(abs(normalized_speed)) * real_max_friction
	velocity.x -= sign(velocity.x) * friction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		coyoteTimer = 0
		if jump_pressed:
			velocity.y -= real_jump_speed
	
	if jump_pressed:
		jumpPressedTimer=0
	if coyoteTimer<=coyoteTime and jumpPressedTimer<=pressedTime:
		velocity.y -= real_jump_speed
		jumpPressedTimer=1000
		coyoteTimer=1000
	jumpPressedTimer+=delta
	coyoteTimer+=delta

func animate():
	# TODO
	pass
