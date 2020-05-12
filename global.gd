extends Node

enum tiles {
	TILE_SOLO = 19,
	TILE_LEFT_TOP = 10,
	TILE_MIDDLE_TOP = 11,
	TILE_RIGHT_TOP = 12,
	TILE_FILLING = 14,
	TILE_FILLING_LEFT=13,
	TILE_FILLING_RIGHT=15,
	TILE_FILLING_SOLO=20,
	TILE_CAP_SOLO=21,
	TILE_CAP_MIDDLE=17,
	TILE_CAP_RIGHT=16,
	TILE_CAP_LEFT=18
}

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
	var value:String setget set_real_value
	var real_value
	var type:String
	var description:String
	var writable:bool
	
	func _init(_aliases = [], _value = "", _type = "Number", _description = "", _writable = true):
		self.aliases = _aliases
		self.type = _type
		self.value = _value
		self.description = _description
		self.writable = _writable
		global.gamevars_list.append(self)
	
	func set_real_value(_val):
		value = _val
		# TODO - Could be cool to add some sort of in game effect if the player inputs the wrong value.
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
onready var help_command = command.new("help", "Display a list of commands", 1)
onready var variables_command = command.new("variables", "Display a list of variables", 1)
onready var set_command = command.new("set", "Set a specified variable to another value", 3)
onready var get_command = command.new("get", "Return a specified variable", 2)
onready var exit_command = command.new("exit", "Exit the hacking interface", 1)
onready var restart_command = command.new("restart", "Restart the game", 1)

#Game Vars
onready var gravity = gamevar.new(["gravity"], "1600", "Number", "The value of the gravity")

#Player Vars
onready var player_fly = gamevar.new(["player_fly", "fly"], "false", "True/False", "The player's ability to fly")
onready var player_fly_speed = gamevar.new(["player_fly_speed", "fly_speed"], "50", "Number", "How fast the player flies")
onready var player_max_speed = gamevar.new(["player_max_speed", "player_speed", "speed"], "700", "Number", "The maximum speed at which the player can go")
onready var player_max_acc = gamevar.new(["player_max_acc", "player_acc", "acc"], "70", "Number", "The maximum acceleration the player can be applying")
onready var player_max_friction = gamevar.new(["player_max_friction", "player_friction", "friction"], "60", "Number", "The maximum friction that can be applied to the player")
onready var player_jump_speed = gamevar.new(["player_jump_speed", "player_jump", "jump"], "350", "Number", "The speed (or force) applied to the player when jumping")
onready var player_health = gamevar.new(["player_health", "health", "hp"], "100", "Number", "The health that the player has")
onready var player_damage_bounce = gamevar.new(["player_damage_bounce", "damage_bounce", "bounce"], "500", "Number", "The amount of knockback the player receives when the player kills an enemy")

#Enemies Vars

#Enemie1 Vars
onready var enemie1_max_speed = gamevar.new(["enemie1_max_speed", "enemie1_speed"], "150", "Number", "The maximum speed at which the Enemie1 can go")

func random_int(minimum, maximum):
	return range(minimum, maximum)[randi() % range(minimum, maximum).size()]

func place_tiles(tilemap, width, base_pos = Vector2.ZERO):
	for i in range(width):
		var final_pos = base_pos + Vector2(i, 0)
		if width == 1:
			tilemap.set_cellv(final_pos, global.tiles.TILE_SOLO)
		else:
			if i == 0:
				tilemap.set_cellv(final_pos, global.tiles.TILE_LEFT_TOP)
			elif i == width - 1:
				tilemap.set_cellv(final_pos, global.tiles.TILE_RIGHT_TOP)
			else:
				tilemap.set_cellv(final_pos, global.tiles.TILE_MIDDLE_TOP)
func make_stack(tilemap, width, height, base_pos= Vector2.ZERO):
	for i in range(height):
		var final_y_pos = base_pos + Vector2(0, i)
		if width==1:
			for i in range(width):
				var final_pos = base_pos + Vector2(i, 0)
				if width == 1:
					tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_SOLO)
				else:
					if i == 0:
						tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_LEFT)
					elif i == width - 1:
						tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_RIGHT)
					else:
						tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_MIDDLE)
			final_y_pos+=1
			for i in range(width):
				var final_pos = base_pos + Vector2(i, 0)
				if width == 1:
					tilemap.set_cellv(final_pos, global.tiles.TILE_SOLO)
				else:
					if i == 0:
						tilemap.set_cellv(final_pos, global.tiles.TILE_LEFT_TOP)
					elif i == width - 1:
						tilemap.set_cellv(final_pos, global.tiles.TILE_RIGHT_TOP)
					else:
						tilemap.set_cellv(final_pos, global.tiles.TILE_MIDDLE_TOP)
		elif i== 0:
			for i in range(width):
				var final_pos = base_pos + Vector2(i, 0)
				if width == 1:
					tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_SOLO)
				else:
					if i == 0:
						tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_LEFT)
					elif i == width - 1:
						tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_RIGHT)
					else:
						tilemap.set_cellv(final_pos, global.tiles.TILE_CAP_MIDDLE)
		elif i==height-1:
			for i in range(width):
				var final_pos = base_pos + Vector2(i, 0)
				if width == 1:
					tilemap.set_cellv(final_pos, global.tiles.TILE_SOLO)
				else:
					if i == 0:
						tilemap.set_cellv(final_pos, global.tiles.TILE_LEFT_TOP)
					elif i == width - 1:
						tilemap.set_cellv(final_pos, global.tiles.TILE_RIGHT_TOP)
					else:
						tilemap.set_cellv(final_pos, global.tiles.TILE_MIDDLE_TOP)
		else:
			for i in range(width):
				var final_pos = base_pos + Vector2(i, 0)
				if width == 1:
					tilemap.set_cellv(final_pos, global.tiles.TILE_FILLING_SOLO)
				else:
					if i == 0:
						tilemap.set_cellv(final_pos, global.tiles.TILE_FILLING_LEFT)
					elif i == width - 1:
						tilemap.set_cellv(final_pos, global.tiles.TILE_FILLING_RIGHT)
					else:
						tilemap.set_cellv(final_pos, global.tiles.TILLE_FILLING_MIDDLE)
			
