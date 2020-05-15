extends Control

signal command_entered
signal input_text_changed

onready var input = get_node("VBoxContainer/Input")
onready var output = get_node("VBoxContainer/Output")

var last_entered_text = ""

func _ready():
	output.scroll_following = true

func _on_Input_text_entered(new_text):
	input.clear()
	output_text(new_text, true)
	if new_text.replace(" ", "") != "":
		emit_signal("command_entered", new_text)
		last_entered_text = new_text

func output_text(text, from_user):
	output.bbcode_text = str(output.bbcode_text, "\n", "[color=red]root@game[color=white]:[color=#33cfff]~[color=greenConsole]# " if from_user else "", text)

func output_error(error):
	output.bbcode_text = str(output.bbcode_text, "\n", error)

func _on_Input_text_changed(_new_text):
	emit_signal("input_text_changed")

func _input(_event):
	if Input.is_action_just_pressed("ui_up"):
		input.text = last_entered_text
