extends KinematicBody2D

var velocity = Vector2()
var speed = 300
var jump_speed = 200
var health = 100
var can_walk = true #For checking if the player is moving
var jump_pressed = false
var gravity = 500

func _ready():
	global.player = self

func _physics_process(delta):
	get_input()
	movement(delta)
	animate()

func get_input():
	# Movement
	var input_velocity = 0
	if Input.is_action_pressed("move_right"):
		input_velocity += 1
	if Input.is_action_pressed("move_left"):
		input_velocity -= 1
	
	velocity.x = input_velocity * speed
	
	jump_pressed = false
	if Input.is_action_pressed("jump"):
		jump_pressed = true

func movement(delta):
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() and jump_pressed:
		velocity.y -= jump_speed

func animate():
	# TODO
	pass
