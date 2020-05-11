extends KinematicBody2D


var velocity = Vector2()

func _process(delta):
	var colision = move_and_collide(velocity)
	if colision: #a simple colision detection
		get_parent().queue_free()
