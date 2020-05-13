extends Area2D

onready var sprite = get_node("Sprite")

const anim_frequency = 3
const anim_size = 10

var time = 0

func _process(delta):
	sprite.position.y = sin(time * anim_frequency) * anim_size
	
	time += delta
