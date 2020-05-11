extends KinematicBody2D

onready var raycast = get_node("RayCast2D")
onready var anim_sprite = get_node("AnimatedSprite")
onready var player_velocity = get_parent().get_node("Player")


var velocity = Vector2()  
const RIGHT = 1
const LEFT = -1
var dir = RIGHT

func _physics_process(delta):
	movement(delta)
	animate()

func movement(delta):
	velocity.x = global.enemie1_max_speed.real_value * dir
	velocity.y += global.gravity.real_value * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player":
			collision.collider.die()
	
	if raycast.is_colliding() == false:
		dir *= LEFT
		raycast.position.x *= LEFT
	
	if is_on_wall():
		dir *= LEFT
		raycast.position.x *= LEFT

func animate():
	if abs(velocity.x) > 0:
		anim_sprite.flip_h = velocity.x < 0
		
		$AnimatedSprite.play("Walk")

func die():
	queue_free()

func _on_Area2D_body_entered(body):
	player_velocity.position.y -= 20
	if body.name == "Player":
		die()
