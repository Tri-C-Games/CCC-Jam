extends CanvasLayer

onready var input = get_node("Hacking GUI/Console/VBoxContainer/Input")

func _ready():
	$"Hacking GUI".visible = false

func _input(_event):
	if Input.is_action_just_pressed("open_console"):
		toggle_console()

func toggle_console():
	input.clear()
	input.grab_focus()
	
	$"Hacking GUI".visible = not $"Hacking GUI".visible
	var tree = get_tree()
	tree.paused = not tree.paused
	
	if tree.paused:
		$"Open SFX".play()
