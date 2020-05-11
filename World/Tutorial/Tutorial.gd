extends Node2D

onready var player = get_node("Player")
onready var dialogue_box = player.get_node("HUD/Dialogue Box")

var received_first_dialogue = false

func _input(_event):
	# Remove this after a dialogue trigger has been added.
	if Input.is_action_just_pressed("delete me"):
		$"Player/HUD/Dialogue Box".start_dialogue("Hello, who are you? I haven't even finished making the game yet.")

func _process(_delta):
	if not received_first_dialogue and player.position.x >= 1100:
		dialogue_box.start_dialogue("Hello, who are you? I haven't even finished making the game yet.")
		received_first_dialogue = true
