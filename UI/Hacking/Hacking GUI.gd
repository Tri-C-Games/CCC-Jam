extends Control

signal exit_pressed

onready var console = get_node("TabContainer/Player/MarginContainer/VBoxContainer/Console")
var success_text = "The \"%s\" command has been used successfully."
var invalid_syntax_text = "Please use the correct syntax."
var not_recognised_text = "\'%s\' is not recognised as an internal or external command,\noperable program or batch file."

var usable_commands = {
	# command : min parameter size
	"set" : 3,
	"get" : 2,
	"exit" : 1
}

func _on_Console_command_entered(command):
	parse_command(command)

func parse_command(text):
	var separated_command = text.split(" ")
	
	var command = separated_command[0].to_lower()
	
	var min_size = usable_commands.get(command)
	if not min_size:
		console.output_error(not_recognised_text % command)
		return
	
	if separated_command.size() < min_size:
		console.output_error(invalid_syntax_text)
		return
	
	var return_success = false;
	
	match command:
		"set":
			var variable = separated_command[1].to_lower()
			var value = global.get(variable)
			if not value:
				console.output_error(not_recognised_text % variable)
				return
			
			var new_value = separated_command[2].to_lower()
			global.set(variable, new_value)
			return_success = true
		"get":
			var variable = separated_command[1].to_lower()
			var value = global.get(variable)
			if not value:
				console.output_error(not_recognised_text % variable)
				return
			
			console.output_text(value, false)
		"exit":
			exit()
	
	if return_success:
		console.output_text(success_text % command, false)

func exit():
	emit_signal("exit_pressed")

func _on_Exit_pressed():
	exit()
