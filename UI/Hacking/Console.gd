extends Control

signal command_entered

onready var input = get_node("VBoxContainer/Input")
onready var output = get_node("VBoxContainer/Output")

func _ready():
	input.grab_focus()

func _on_Input_text_entered(new_text):
	input.clear()
	output_text(new_text)
	emit_signal("command_entered", new_text)

func output_text(text):
	output.text = str(output.text, "\n", "C:\\>", text)

func _on_Output_cursor_changed():
	# Automatic scrolling.
	var line_count = output.get_line_count()
	output.cursor_set_line(line_count)

func print_console(text):
	output.text = str(output.text, "\n", text)
