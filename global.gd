extends Node

var commands_list = []
var gamevars_list = []

class command:
	var name:String
	var description:String
	var min_parameters:int
	
	func _init(_name = "", _description = "", _min_parameters = 0):
		self.name = _name
		self.description = _description
		self.min_parameters = _min_parameters
		global.commands_list.append(self)
	
	static func get_command(cmd_name):
		for command in global.commands_list:
			if command.name == cmd_name:
				return command

class gamevar:
	var aliases
	var value:String
	var type
	var description:String
	var writable:bool#: bool=true # Already set to true by default in the init.
	
	func _init(_aliases = [], _value = "", _type = "String", _description = "", _writable = true):
		self.aliases = _aliases
		self.value = _value
		self.type = _type
		self.description = _description
		self.writable = _writable
		global.gamevars_list.append(self)
	
	static func get_gamevar(name):
		for gamevar in global.gamevars_list:
			for alias in gamevar.aliases:
				if name == alias and gamevar.writable:
					return gamevar

#func gamevar(var value:String="", var description:String="", var writable:bool=true):
#	var variable=gamevar.new()
#	variable.value=value
#	variable.description=description
#	variable.writable=writable
#	#variable.writable=writable # No need for two.
#	return variable

#var gravity : gamevar
#var player_fly : gamevar
#var player_max_speed : gamevar
#var player_max_acc : gamevar
#var player_max_friction : gamevar
#var player_jump_speed : gamevar
#var player_health : gamevar

onready var help_command = command.new("help", "Display a list of commands", 1)
onready var variables_command = command.new("variables", "Display a list of variables", 1)
onready var set_command = command.new("set", "Set a specified variable to another value", 3)
onready var get_command = command.new("get", "Return a specified variable", 2)
onready var exit_command = command.new("exit", "Exit the hacking interface", 1)
onready var restart_command = command.new("restart", "Restart the game", 1)

onready var gravity = gamevar.new(["gravity"], "500", "Number", "The value of the gravity")
onready var player_fly = gamevar.new(["player_fly"], "false", "True/False", "The player's ability to fly")
onready var player_max_speed = gamevar.new(["player_max_speed", "player_speed"], "600", "Number", "The maximum speed at which the player can go")
onready var player_max_acc = gamevar.new(["player_max_acc", "player_acc"], "70", "Number", "The maximum acceleration the player can be applying")
onready var player_max_friction = gamevar.new(["player_max_friction", "player_friction"], "60", "Number", "The maximum friction that can be applied to the player")
onready var player_jump_speed = gamevar.new(["player_jump_speed", "player_jump"], "200", "Number", "The speed (or force) applied to the player when jumping")
onready var player_health = gamevar.new(["player_health"], "100", "Number", "The health that the player has")

#func _init():
#	gravity= gamevar("500", "The value of the gravity")
#	player_fly= gamevar("false", "The player's ability to fly")
#	player_max_speed= gamevar("600", "The maximum speed at which the player can go")
#	player_max_acc= gamevar("70", "The maximum acceleration the player can be applying")
#	player_max_friction= gamevar("60","The maximum friction that can be applied to the player")
#	player_jump_speed=gamevar("200", "The speed (or force) applied to the player when jumping")
#	player_health=gamevar("100", "The health that the player has")
