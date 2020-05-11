extends Area2D

var velocity = Vector2()

var width

func set_width(_width):
	width = _width
	
	var tilemap = get_node("TileMap")
	
	for i in range(width):
		if i == 0 and width == 1:
			tilemap.set_cellv(Vector2(i, 0), global.tiles.TILE_SOLO)
		else:
			if i == 0:
				tilemap.set_cellv(Vector2(i, 0), global.tiles.TILE_LEFT)
			elif i == width - 1:
				tilemap.set_cellv(Vector2(i, 0), global.tiles.TILE_RIGHT)
			else:
				tilemap.set_cellv(Vector2(i, 0), global.tiles.TILE_MIDDLE)
	
	$CollisionShape2D.position = Vector2(32 * width, 32)
	$CollisionShape2D.shape.extents.x = 32 * width

func _physics_process(delta):
	velocity.y += global.gravity.real_value * delta
	position += velocity * delta

func _on_Falling_Tiles_body_entered(body):
	if body.has_method("stack_tile"):
		body.stack_tile(position, width)
		queue_free()
