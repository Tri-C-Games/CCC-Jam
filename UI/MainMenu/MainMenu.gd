extends Control

func _on_Button_pressed():
	if get_tree().change_scene("res://World/Tutorial/Tutorial.tscn") != OK:
		print_debug("An error occurred while attempting to change to the tutorial scene.")

func _on_Button2_pressed():
	if get_tree().change_scene("res://World/Levels/Level6.tscn") != OK:
		print_debug("An error occured while attemtping to change to the sandbox scene.")
