extends CanvasLayer

onready var input = get_node("Hacking GUI/Console/VBoxContainer/Input")
onready var hacking_gui = get_node("Hacking GUI")
onready var open_console_button = get_node("Console Button")

func _ready():
	hacking_gui.visible = false
	open_console_button.visible = false

func _input(_event):
	if Input.is_action_just_pressed("open_console") and global.can_open_console :
		toggle_console()

func toggle_console():
	input.clear()
	input.grab_focus()
	
	hacking_gui.visible = not hacking_gui.visible
	var tree = get_tree()
	tree.paused = not tree.paused

func enable_open_console():
	global.can_open_console = true
	open_console_button.visible = true
