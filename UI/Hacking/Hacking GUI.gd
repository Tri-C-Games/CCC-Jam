extends Control

onready var console = get_node("TabContainer/Player/MarginContainer/VBoxContainer/Console")
onready var player = preload("res://Player/Scenes/Player.tscn").instance()
var success_text = "The \"%s\" command has been used successfully."
var error_text = "\'%s\' is not recognised as an internal or external command,\noperable program or batch file."

var usable_commands = [
	"set"
]

func _on_Console_command_entered(command):
	parse_command(command)

func parse_command(text):
	var separated_command = text.split(" ")
	var command = separated_command[0].to_lower()
	if (command in usable_commands):
		console.output_text(success_text % command, false)
	else:
		console.output_error(error_text % command)
