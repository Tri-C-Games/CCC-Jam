extends Node2D

func _input(_event):
	# Remove this after a dialogue trigger has been added.
	if Input.is_action_just_pressed("delete me"):
		$"Player/HUD/Dialogue Box".start_dialogue("Hello, who are you? I haven't even finished making the game yet.")
		$"Player/HUD/Dialogue Box".buffer_dialogue("What are you saying? It's already on itch?")
		$"Player/HUD/Dialogue Box".buffer_dialogue("Oh crap oh crap... Hey, i have an idea! My game isn't balanced, can you balance it for me?")
