extends KinematicBody2D

var velocity = Vector2()
var max_speed = 300 #max speed of the player
var can_walk = true #for checking if the player use inventory etc... and if it false than the player can't walkvar i_is_pressed = false #for checking if the player is showing the inventory
func _physics_process(delta):
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left") and can_walk:
		velocity.x =  max_speed
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") and can_walk:
		velocity.x =  -max_speed
	else:
		velocity.x = 0
	var motion = move_and_collide(velocity * delta) 
	
