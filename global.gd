extends Node

var can_open_console = false

enum tiles {
	TILE_SOLO = 3
	TILE_LEFT = 7,
	TILE_MIDDLE = 8,
	TILE_RIGHT = 9
	TILE_FILLING
}

var commands_list = []
var gamevars_list = []

var upgrade_path = [["gravity", "player_jump_speed"], ["player_size"], ["player_health"], ["player_max_speed", "player_max_acc"], ["time_scale"]]

func upgrade(dialogue_box, path_number, display_dialogue = false):
	for item in upgrade_path[path_number]:
		get(item).writable=true
	
	if display_dialogue:
		var text = "I have added some new variables that you can now use!"
		dialogue_box.buffer_dialogue(text)

func unlock_all_vars():
	for gamevar in global.gamevars_list:
		gamevar.writable = true

class command:
	var aliases
	var description:String
	var syntax:String
	var min_parameters:int
	
	func _init(_aliases = [], _description = "", _min_parameters = 0, _syntax = ""):
		self.aliases = _aliases
		self.description = _description
		self.syntax = _syntax
		self.min_parameters = _min_parameters
		global.commands_list.append(self)
	
	static func get_command(cmd_name):
		for command in global.commands_list:
			for alias in command.aliases:
				if cmd_name == alias:
					return command

class gamevar:
	var aliases
	var default_value:String
	var value:String setget set_real_value
	var real_value
	var min_real_value
	var max_real_value
	var type:String
	var description:String
	var writable:bool
	
	func _init(_min_real_value, _max_real_value, _aliases = [], _value = "", _type = "Number", _description = "", _writable = false):
		self.min_real_value = _min_real_value
		self.max_real_value = _max_real_value
		self.aliases = _aliases
		self.type = _type
		self.value = _value
		self.default_value = self.value
		self.description = _description
		self.writable = _writable
		global.gamevars_list.append(self)
	
	func is_value_valid():
		match self.type:
			"Number":
				return self.value.is_valid_float()
			"True/False":
				return self.value == "true" || value == "false"
	
	func set_real_value(_val):
		value = _val
		match self.type:
			"Number":
				self.real_value = float(value) if value.is_valid_float() else 0.0
				if self.min_real_value != null and self.max_real_value != null:
					self.real_value = clamp(self.real_value, self.min_real_value, self.max_real_value)
			"True/False":
				self.real_value = true if value == "true" else false
	
	static func get_gamevar(name):
		for gamevar in global.gamevars_list:
			for alias in gamevar.aliases:
				if name == alias and gamevar.writable:
					return gamevar
	
	static func reset_gamevars():
		for gamevar in global.gamevars_list:
			gamevar.value = gamevar.default_value

#Commands
onready var help_command = command.new(["help", "info", "tutorial"], "Display a list of commands", 1,
"help - What do you expect this to tell you? It's just a help command.")
onready var variables_command = command.new(["variables", "variable", "vars", "var"], "Display a list of variables", 1,
"variables - What did you expect this to tell you? It's just a variable list.")
onready var set_command = command.new(["set", "change"], "Set a specified variable to another value", 3,
"set [variable name] [value]")
onready var get_command = command.new(["get", "return"], "Return a specified variable", 2,
"get [variable name]")
onready var exit_command = command.new(["exit", "quit", "stop"], "Exit the developer console", 1,
"exit - What did you expect this to tell you? It just exits the menu.")
onready var restart_command = command.new(["restart", "redo", "reset"], "Completely restart the game", 1,
"restart - What did you expect this to tell you? It just restarts the game.")

#Game Vars
onready var gravity = gamevar.new(-99999, 99999, ["gravity"], "1800", "Number",
"The value of gravity")
onready var time_scale = gamevar.new(null, null, ["time_scale", "time"], "1", "Number",
"A multiplier for the rate of time")

#Player Vars
onready var player_fly = gamevar.new(null, null, ["player_fly", "fly"], "false", "True/False",
"Whether or not the player can fly")
onready var player_fly_speed = gamevar.new(-99999, 99999, ["player_fly_speed", "fly_speed"], "900", "Number",
"How fast the player flies")
onready var player_max_speed = gamevar.new(-99999, 99999, ["player_max_speed", "player_speed", "speed"], "700", "Number",
"The maximum speed at which the player can move")
onready var player_max_acc = gamevar.new(-99999, 99999, ["player_max_acc", "player_acc", "acc"], "70", "Number",
"The maximum acceleration the player can be applying")
onready var player_max_friction = gamevar.new(-99999, 99999, ["player_max_friction", "player_friction", "friction"], "60", "Number",
"The maximum friction that can be applied to the player")
onready var player_jump_speed = gamevar.new(-99999, 99999, ["player_jump_speed", "player_jump", "jump"], "900", "Number",
"The speed (or force) applied to the player when jumping")
onready var player_health = gamevar.new(-99999, 99999, ["player_health", "health", "hp"], "1", "Number",
"The health that the player has")
onready var player_damage_bounce = gamevar.new(-99999, 99999, ["player_damage_bounce", "damage_bounce", "bounce", "enemy_bounce"], "500", "Number",
"The amount of knockback the player receives when the player kills an enemy")
onready var player_size = gamevar.new(null, null, ["player_size", "player_scale", "size", "scale"], "1", "Number",
"A multiplier for how big the player is")

#Enemy Vars
onready var enemy_max_speed = gamevar.new(-99999, 99999, ["enemy_max_speed", "enemy_speed"], "150", "Number",
"The maximum speed at which the enemy can move")

func random_int(minimum, maximum):
	return range(minimum, maximum)[randi() % range(minimum, maximum).size()]

func place_tiles(tilemap, width, base_pos = Vector2(0, 0)):
	for i in range(width):
		var final_pos = base_pos + Vector2(i, 0)
		if width == 1:
			tilemap.set_cellv(final_pos, global.tiles.TILE_SOLO)
		else:
			if i == 0:
				tilemap.set_cellv(final_pos, global.tiles.TILE_LEFT)
			elif i == width - 1:
				tilemap.set_cellv(final_pos, global.tiles.TILE_RIGHT)
			else:
				tilemap.set_cellv(final_pos, global.tiles.TILE_MIDDLE)

func restart():
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while attempting to reload the current scene.")

func complete_restart(go_to_menu = false):
	global.can_open_console = false
	global.gamevar.reset_gamevars()
	if go_to_menu:
		if get_tree().change_scene("res://UI/MainMenu/MainMenu.tscn") != OK:
			print_debug("An error occurred while attempting to go to the main menu.")
	else:
		restart()

var level = 1
func go_to_next_level():
	level += 1
	if get_tree().change_scene("res://World/Levels/Level%s.tscn" % level) != OK:
		print_debug("An error occurred while attempting to go to the next level.")
