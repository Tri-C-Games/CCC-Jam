extends KinematicBody2D

var velocity = Vector2()
var player_speed = 300 #max speed of the player
var player_jump_speed = 10
var player_health = 100 #the health of the payer
var can_walk = true #for checking if the player is mouving
var can_jump = true #fir checking if the player is in a platform
var gravity = 5 #the gravity value

func _physics_process(delta):
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") and can_walk:
		velocity.x =  player_speed
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and can_walk:
		velocity.x =  -player_speed
	else:
		velocity.x = 0
	if Input.is_action_pressed("ui_up") and can_jump:
		can_jump = false
		velocity.y -= player_jump_speed
	if is_on_floor():
		can_jump = true
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
