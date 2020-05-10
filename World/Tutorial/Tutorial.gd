extends Node2D

func _input(_event):
	if Input.is_action_just_pressed("delete me"):
		$"Player/HUD/Dialogue Box".start_dialogue("Hello, who are you? I haven't even finished making the game yet.")
