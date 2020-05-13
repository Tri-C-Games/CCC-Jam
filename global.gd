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

var next_upgrade_path_progression:int=0

var upgrade_path= [["gravity", "player_jump_speed"]]

func upgrade(dialogue_box):
	
	var popup_text= "Hey, I just remembered! Maybe you would find the vars [color=blue]"
	for item in upgrade_path[next_upgrade_path_progression]:
		get(item).writable=true
		popup_text+= item+", "
	
	popup_text+="[color=black]useful."
	popup_text+= "[color=red] Use the variables command to see what they are.[color=black]"
	dialogue_box.buffer_dialogue(popup_text)
	next_upgrade_path_progression+=1

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
	var value:String setget set_real_value
	var real_value
	var type:String
	var description:String
	var writable:bool
	
	func _init(_aliases = [], _value = "", _type = "Number", _description = "", _writable = false):
		self.aliases = _aliases
		self.type = _type
		self.value = _value
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
			"True/False":
				self.real_value = true if value == "true" else false
	
	static func get_gamevar(name):
		for gamevar in global.gamevars_list:
			for alias in gamevar.aliases:
				if name == alias and gamevar.writable:
					return gamevar

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
onready var restart_command = command.new(["restart", "redo", "reset"], "Restart the game", 1,
"restart - What did you expect this to tell you? It just restarts the game.")

#Game Vars
onready var gravity = gamevar.new(["gravity"], "1800", "Number",
"The value of gravity")

#Player Vars
onready var player_fly = gamevar.new(["player_fly", "fly"], "false", "True/False",
"Whether or not the player can fly")
onready var player_fly_speed = gamevar.new(["player_fly_speed", "fly_speed"], "50", "Number",
"How fast the player flies")
onready var player_max_speed = gamevar.new(["player_max_speed", "player_speed", "speed"], "700", "Number",
"The maximum speed at which the player can move")
onready var player_max_acc = gamevar.new(["player_max_acc", "player_acc", "acc"], "70", "Number",
"The maximum acceleration the player can be applying")
onready var player_max_friction = gamevar.new(["player_max_friction", "player_friction", "friction"], "60", "Number",
"The maximum friction that can be applied to the player")
onready var player_jump_speed = gamevar.new(["player_jump_speed", "player_jump", "jump"], "900", "Number",
"The speed (or force) applied to the player when jumping")
onready var player_health = gamevar.new(["player_health", "health", "hp"], "100", "Number",
"The health that the player has")
onready var player_damage_bounce = gamevar.new(["player_damage_bounce", "damage_bounce", "bounce", "enemy_bounce"], "500", "Number",
"The amount of knockback the player receives when the player kills an enemy")

#Enemy Vars
onready var enemy_max_speed = gamevar.new(["enemy_max_speed", "enemy_speed"], "150", "Number",
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

func go_to_next_level():
	# TODO
	if get_tree().change_scene("res://World/Levels/Level2.tscn") != OK:
		print_debug("An error occurred while attempting to go to the next level.")
