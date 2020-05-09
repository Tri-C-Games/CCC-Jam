extends Control

signal exit_pressed
signal set_command_used

onready var console = get_node("TabContainer/Player/MarginContainer/VBoxContainer/Console")
var success_text = "The \"%s\" command has been used successfully."
var invalid_syntax_text = "Please use the correct syntax."
var not_recognised_text = "\'%s\' is not recognised as an internal or external command,\noperable program or batch file."

var usable_commands = [
	"set"
]

var usable_types = [
	"player"
]

var usable_player_variables = {
	"speed" : 0
}

func _on_Console_command_entered(command):
	parse_command(command)

func parse_command(text):
	var separated_command = text.split(" ")
	
	var command = separated_command[0].to_lower()
	if not command in usable_commands:
		console.output_error(not_recognised_text % command)
		return
	
	var min_size
	match separated_command[0]:
		"set":
			min_size = 4
	
	if separated_command.size() < min_size:
		console.output_error(invalid_syntax_text)
		return
	
	var type = separated_command[1].to_lower()
	if not type in usable_types:
		console.output_error(not_recognised_text % type)
		return
	
	match type:
		"player":
			var variable = separated_command[2].to_lower()
			if not variable in usable_player_variables:
				console.output_error(not_recognised_text % type)
				return
			
			match variable:
				"speed":
					var result = separated_command[3]
					if result.is_valid_integer():
						global.player.speed = int(result)
					else:
						# TODO - Could be cool to add some sort of in game effect if the player inputs a string.
						pass
	
	console.output_text(success_text % command, false)

func _on_Exit_pressed():
	emit_signal("exit_pressed")
