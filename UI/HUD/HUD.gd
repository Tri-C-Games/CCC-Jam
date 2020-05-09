extends CanvasLayer

func open_console():
	if get_tree().change_scene("res://UI/Hacking/Hacking GUI.tscn") != OK:
		print_debug("An error occured while attempting to open the console.")
