extends Control

signal command_entered

onready var input = get_node("VBoxContainer/Input")
onready var output = get_node("VBoxContainer/Output")

func _ready():
	input.grab_focus()
	output.scroll_following = true

func _on_Input_text_entered(new_text):
	input.clear()
	output_text(new_text, true)
	emit_signal("command_entered", new_text)

func output_text(text, from_user):
	output.bbcode_text = str(output.bbcode_text, "\n", "[color=red]root@game[color=white]:[color=#33cfff]~[color=greenConsole]# " if from_user else "", text)

func output_error(error):
	output.bbcode_text = str(output.bbcode_text, "\n[color=greenConsole]", error, "[/color]")
