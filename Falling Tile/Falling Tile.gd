extends Area2D

var velocity = Vector2()

var width

func _ready():
	$TileMap.set_cellv(Vector2(0, 0), 1)

func set_width(_width):
	width = _width
	global.place_tiles(get_node("TileMap"), width)
	
	for i in width:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = RectangleShape2D.new()
		collision_shape.shape.extents = Vector2(30, 30) # Note that it is intentionally slightly smaller than 32x32.
		collision_shape.position = Vector2(64 * i + 32, 32)
		add_child(collision_shape)

func _physics_process(delta):
	velocity.y += global.gravity.real_value * delta
	position += velocity * delta

func _on_Falling_Tiles_body_entered(body):
	if body.has_method("stack_tile"):
		body.stack_tile(position, width)
		queue_free()
