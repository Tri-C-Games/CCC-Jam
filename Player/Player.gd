extends KinematicBody2D

onready var anim_sprite = get_node("AnimatedSprite")
onready var left_raycast = get_node("Left RayCast")
onready var middle_raycast = get_node("Middle RayCast")
onready var right_raycast = get_node("Right RayCast")
onready var raycasts = [left_raycast, middle_raycast, right_raycast]

var velocity = Vector2()
var jump_pressed = false

export (Curve) var acc_curve
export (Curve) var friction_curve
export (Curve) var anim_speed_curve

const rotation_weight = 0.2

var coyoteTime = 0;#in seconds
var pressedTime = 0.2 #in seconds, anti input frustration value
var coyoteTimer = 10
var jumpPressedTimer=10

var input_velocity = 0

func _physics_process(delta):
	input_velocity = 0
	get_input()
	movement(delta)
	animate()

func get_input():
	# Movement
	if Input.is_action_pressed("move_right"):
		input_velocity += 1
	if Input.is_action_pressed("move_left"):
		input_velocity -= 1
	
	if global.player_max_speed.real_value != 0:
		var normalized_speed = range_lerp(velocity.x, 0, global.player_max_speed.real_value, 0, 1)
		var acc = acc_curve.interpolate(abs(normalized_speed)) * global.player_max_acc.real_value
		velocity.x += input_velocity * acc
	
	jump_pressed = false
	if Input.is_action_pressed("jump") if not global.player_fly.real_value else Input.is_action_just_pressed("jump"):
		jump_pressed = true

func movement(delta):
	if not is_on_floor() and global.gravity.real_value > 0:#any_raycasts_colliding():# and global.gravity.real_value > 0:
		velocity.y += global.gravity.real_value * delta
	
	# Friction
	if global.player_max_speed.real_value != 0:
		var normalized_speed = range_lerp(velocity.x, 0, global.player_max_speed.real_value, 0, 1)
		var friction = friction_curve.interpolate(abs(normalized_speed)) * global.player_max_friction.real_value
		velocity.x -= sign(velocity.x) * friction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() || global.player_fly.real_value:
		coyoteTimer = 0
		if jump_pressed:
			velocity.y -= global.player_jump_speed.real_value if not global.player_fly.real_value else global.player_fly_speed.real_value
	
	if jump_pressed:
		jumpPressedTimer=0
	if coyoteTimer<=coyoteTime and jumpPressedTimer<=pressedTime:
		velocity.y -= global.player_jump_speed.real_value
		jumpPressedTimer=1000
		coyoteTimer=1000
	jumpPressedTimer+=delta
	coyoteTimer+=delta

func animate():
	var moving = abs(velocity.x) > 0
	if moving:
		anim_sprite.flip_h = velocity.x < 0
	
	var normal = get_average_normal()
	if normal != Vector2.ZERO:
		anim_sprite.rotation = lerp(anim_sprite.rotation, normal.angle() + TAU/4, rotation_weight)
	else:
		anim_sprite.rotation = lerp(anim_sprite.rotation, 0, rotation_weight)
	
	if not any_raycasts_colliding():
		if velocity.y < 0:
			anim_sprite.play("Jump")
		else:
			anim_sprite.play("Fall")
		
		return
	
	if input_velocity != 0 and moving:
		var speed_scale = anim_speed_curve.interpolate(abs(velocity.x)/1000)
		anim_sprite.speed_scale = speed_scale
		anim_sprite.frames.set_animation_loop("Walk", true)
		anim_sprite.play("Walk")
	else:
		anim_sprite.play("Idle")

func die():
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occured while attempting to reload the current scene.")

func any_raycasts_colliding():
	for raycast in raycasts:
		if raycast.is_colliding():
			return true
	return false

func all_raycasts_colliding():
	for raycast in raycasts:
		if not raycast.is_colliding():
			return false
	return true

func get_average_normal():
	if all_raycasts_colliding():
		return (left_raycast.get_collision_normal() + middle_raycast.get_collision_normal() + right_raycast.get_collision_normal())/3
	return Vector2.ZERO

func knockback(amount, dir):
	velocity += Vector2(amount, 0).rotated(dir.angle())
