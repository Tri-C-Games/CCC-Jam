extends Node2D

onready var player = get_node("Player")
onready var dialogue_box = player.get_node("HUD/Dialogue Box")

var received_first_dialogue = false

func _process(_delta):
	if not received_first_dialogue and player.position.x >= 1100:
		received_first_dialogue = true
		dialogue_box.start_dialogue("Hello, who are you? I haven't even finished making the game yet.")
		dialogue_box.buffer_dialogue("What are you saying? It's already on itch?")
		dialogue_box.buffer_dialogue("Oh crap, oh crap... Hey, I have an idea! My game isn't finished, can you finish it for me?")
