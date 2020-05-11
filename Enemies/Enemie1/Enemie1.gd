extends KinematicBody2D

var velocity = Vector2()  
const RIGHT = 1
const LEFT = -1
var dir = RIGHT

func _physics_process(delta):
	velocity.x = global.enemie1_max_speed.real_value * dir
	velocity.y += global.gravity.real_value * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			collision.collider.die()
	
	if $RayCast2D.is_colliding() == false:
		dir *= LEFT
		$RayCast2D.position.x *= LEFT
	
	if is_on_wall():
		dir *= LEFT
		$RayCast2D.position.x *= LEFT

func die():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		die()
