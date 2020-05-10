extends Control

signal exit_pressed

onready var console = get_node("Console")
var success_text = "The \"%s\" command has been used successfully."
var invalid_syntax_text = "Please use the correct syntax."
var not_recognised_text = "\'%s\' is not recognised as an internal or external command,\noperable program or batch file."

var usable_commands = {
	# command : min parameter size
	"set" : 3,
	"get" : 2,
	"exit" : 1,
	"restart" : 1,
	"fly" : 2,
	"help" : 1,
	"variables": 1
}

func _on_Console_command_entered(command):
	parse_command(command)

func parse_command(text):
	# Separate the command into words. E.g. "set player_max_speed 100" will return ["set", "player_max_speed", "100"].
	var separated_command = text.split(" ")
	
	# Lower case to ensure that even if the player adds an extra capital somewhere that it will still work fine.
	var command = separated_command[0].to_lower()
	
	# Some commands need more parameters than others. E.g. The set command needs the variable changed and the new value while exit doesn't need anything else.
	var min_size = usable_commands.get(command)
	if not min_size:
		console.output_error(not_recognised_text % command)
		return
	
	# If the user doesn't use enough parameters then output an error.
	if separated_command.size() < min_size:
		console.output_error(invalid_syntax_text)
		return
	
	# Different commands do different things.
	match command:
		"set":
			var variable = separated_command[1].to_lower()
			
			# Check if the variable actually exists.
			var value = global.get(variable)
			if not value:
				console.output_error(not_recognised_text % variable)
				return
			
			# Change the variable's value to the new value that the player chose.
			var new_value = separated_command[2].to_lower()
			global.get(variable).value=new_value
			
			console.output_text("[i]%s has been set to %s.[/i]" % [variable, new_value], false)
		"get":
			var variable = separated_command[1].to_lower()
			
			# Check if the variable actually exists.
			var value = global.get(variable.value)
			if not value:
				console.output_error(not_recognised_text % variable)
				return
			
			# If it does then output the variable's value.
			console.output_text(value, false)
		"exit":
			exit()
		"restart":
			exit()
			restart()
		"help":
			console.output_text("set: to set variable values\nget: to get variable values\nexit: back to da game\nrestart: Everyone has a second chance", false)
		"variables":
			var list=global.get_property_list()
			var gamevars
			console.output_text("list of variables",false)
			for item in list:
				if item["type"]==typeof(global.gamevar):
					gamevars.push_back(item["name"])
			for item in gamevars:
				if global.get(item).writable:
					console.output_text(item+": "+global.get(item).description,false)

func exit():
	emit_signal("exit_pressed")

func _on_Exit_pressed():
	exit()

func restart():
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while attempting to reload the current scene.")
