extends KinematicBody2D

var velocity = Vector2()
var can_walk = true #For checking if the player is moving
var jump_pressed = false

export (Curve) var acc_curve
export (Curve) var friction_curve

var coyoteTime = 0;#in seconds
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
	
	if global.player_max_speed.real_value != 0:
		var normalized_speed = range_lerp(velocity.x, 0, global.player_max_speed.real_value, 0, 1)
		var acc = acc_curve.interpolate(abs(normalized_speed)) * global.player_max_acc.real_value
		velocity.x += input_velocity * acc
	
	jump_pressed = false
	if global.player_fly.value == "false":
		if Input.is_action_pressed("jump"):
			jump_pressed = true
	
	if global.player_fly.value == "true":
		if Input.is_action_pressed("jump"):
			velocity.y -= 10

func movement(delta):
	velocity.y += global.gravity.real_value * delta
	
	# Friction
	if global.player_max_speed.real_value != 0:
		var normalized_speed = range_lerp(velocity.x, 0, global.player_max_speed.real_value, 0, 1)
		var friction = friction_curve.interpolate(abs(normalized_speed)) * global.player_max_friction.real_value
		velocity.x -= sign(velocity.x) * friction

	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		coyoteTimer = 0
		if jump_pressed:
			velocity.y -= global.player_jump_speed.real_value
	
	if jump_pressed:
		jumpPressedTimer=0
	if coyoteTimer<=coyoteTime and jumpPressedTimer<=pressedTime:
		velocity.y -= global.player_jump_speed.real_value
		jumpPressedTimer=1000
		coyoteTimer=1000
	jumpPressedTimer+=delta
	coyoteTimer+=delta

func animate():
	# TODO
	pass

func die():
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occured while attempting to reload the current scene.")
