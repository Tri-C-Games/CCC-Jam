extends KinematicBody2D

onready var raycast = get_node("RayCast2D")
onready var anim_sprite = get_node("AnimatedSprite")
onready var right_raycast = get_node("Right Raycast")
onready var left_raycast = get_node("Left Raycast")
onready var up_raycast = get_node("Up Raycast")

var velocity = Vector2()  
const RIGHT = 1
const LEFT = -1
var dir = RIGHT

func _physics_process(delta):
	movement(delta)
	animate()

func movement(delta):
	velocity.x = global.enemy_max_speed.real_value * dir
	velocity.y += global.gravity.real_value * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if raycast.is_colliding() == false:
		dir *= LEFT
		raycast.position.x *= LEFT
	
	if is_on_wall():
		dir *= LEFT
		raycast.position.x *= LEFT
	
	# If trapped (may be due to the falling tiles).
	if right_raycast.is_colliding() and left_raycast.is_colliding() and up_raycast.is_colliding():
		die()

func animate():
	if abs(velocity.x) > 0:
		anim_sprite.flip_h = velocity.x < 0
		
		anim_sprite.play("Walk")

func die():
	queue_free()

func _on_Die_Zone_body_entered(body):
	if body.has_method("knockback"):
		body.knockback(global.player_damage_bounce.real_value, Vector2.UP)
		die()

func _on_Kill_Zone_body_entered(body):
	if body.name == "Player":
		body.die()
