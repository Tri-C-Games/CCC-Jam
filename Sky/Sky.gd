extends ParallaxBackground

onready var clouds = get_node("Clouds")

var cloud_velocity = Vector2(30, 0)

func _process(delta):
	clouds.motion_offset = clouds.motion_offset + cloud_velocity * delta
