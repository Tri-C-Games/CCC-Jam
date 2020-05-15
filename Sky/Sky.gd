extends ParallaxBackground

onready var clouds = get_node("Clouds")
onready var clouds2 = get_node("Clouds2")

var cloud_velocity = Vector2(10, 0)
var cloud2_velocity = Vector2(30, 0)

func _process(delta):
	clouds.motion_offset = clouds.motion_offset + cloud_velocity * delta
	clouds2.motion_offset = clouds2.motion_offset + cloud2_velocity * delta
