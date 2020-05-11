extends KinematicBody2D


var velocity = Vector2()  
var flooros = Vector2(0, -1)
var right = 1
var left = -1
var dir = right



func _process(delta):
	velocity.x = global.enemie1_max_speed.real_value * dir
	velocity.y += global.gravity.real_value
	velocity = move_and_slide(velocity, flooros)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			get_tree().reload_current_scene()
		
	if $RayCast2D.is_colliding() == false:
		dir *= left
		$RayCast2D.position.x *= left
	
	if is_on_wall():
		dir *= left
		$RayCast2D.position.x *= left
		
	
