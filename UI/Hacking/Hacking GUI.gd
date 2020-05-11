extends Control

signal exit_pressed

onready var console = get_node("Console")
var success_text = "The \"%s\" command has been used successfully."
var invalid_syntax_text = "Please use the correct syntax."
var not_recognised_text = "\'%s\' is not recognised as an internal or external command,\noperable program or batch file."

func _on_Console_command_entered(command):
	parse_command(command)

func parse_command(text):
	# Separate the command into words. E.g. "set player_max_speed 100" will return ["set", "player_max_speed", "100"].
	var separated_command = text.split(" ")
	
	# Lower case to ensure that even if the player adds an extra capital somewhere that it will still work fine.
	var command_str = separated_command[0].to_lower()
	var command = global.command.get_command(command_str)
	
	# If the command doesn't exist.
	if not command:
		console.output_error(not_recognised_text % command_str)
		return
	
	if separated_command.size() < command.min_parameters:
		console.output_error(invalid_syntax_text)
		return
	
	# Different commands do different things.
	match command.name:
		"set":
			var variable_str = separated_command[1].to_lower()
			var variable = global.gamevar.get_gamevar(variable_str)
			if not variable:
				console.output_error(not_recognised_text % variable_str)
				return
			
			var new_value = separated_command[2].to_lower()
			variable.value = new_value
			
			console.output_text("[i]%s has been set to %s.[/i]" % [variable_str, new_value], false)
		"get":
			var variable_str = separated_command[1].to_lower()
			var variable = global.gamevar.get_gamevar(variable_str)
			if not variable:
				console.output_error(not_recognised_text % variable_str)
				return
			
			console.output_text(variable.value, false)
		"exit":
			exit()
		"restart":
			exit()
			restart()
		"help":
			var output = "Commands:\n"
			for command in global.commands_list:
				output += str(command.name, " - ", command.description, "\n")
			output = output.trim_suffix("\n")
			console.output_text(output, false)
		"variables":
			var output = "Variables:\n"
			for variable in global.gamevars_list:
				if variable.writable:
					output += "%s : %s - %s\n" % [variable.aliases[0], variable.type, variable.description]
			
			output = output.trim_suffix("\n")
			console.output_text(output, false)

func exit():
	emit_signal("exit_pressed")

func _on_Exit_pressed():
	exit()

func restart():
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while attempting to reload the current scene.")

func _on_Console_input_text_changed():
	$"Key Press SFX".play()
