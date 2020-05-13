extends Area2D

var velocity = Vector2()

var width

func set_width(_width):
	width = _width
	global.place_tiles(get_node("TileMap"), width)
	
	$CollisionShape2D.position = Vector2(32 * width, 32)
	$CollisionShape2D.shape.extents.x = 32 * width

func _physics_process(delta):
	velocity.y += global.gravity.real_value * delta
	position += velocity * delta

func _on_Falling_Tiles_body_entered(body):
	if body.has_method("stack_tile"):
		body.stack_tile(position, width)
		queue_free()
