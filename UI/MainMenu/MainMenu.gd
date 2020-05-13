extends MarginContainer

func _on_Button_pressed():
	if get_tree().change_scene("res://World/Tutorial/Tutorial.tscn") != OK:
		print_debug("An error occurred while attempting to change to the tutorial scene.")
