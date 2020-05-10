extends Node

# All variables in here will be changeable in the console.
class gamevar:
	var value:String
	var description:String
	var writable: bool=true
	
func gamevar(var value:String="", var description:String="", var writable:bool=true):
	var variable=gamevar.new()
	variable.value=value
	variable.description=description
	variable.writable=writable
	variable.writable=writable
	return variable

var gravity:gamevar
var player_fly:gamevar
var player_max_speed:gamevar
var player_max_acc:gamevar
var player_max_friction:gamevar
var player_jump_speed:gamevar
var player_health:gamevar

func _init():
	gravity= gamevar("500", "The value of the gravity")
	player_fly= gamevar("false", "The player's ability to fly")
	player_max_speed= gamevar("600", "The maximum speed at which the player can go")
	player_max_acc= gamevar("70", "The maximum acceleration the player can be applying")
	player_max_friction= gamevar("60","The maximum friction that can be applied to the player")
	player_jump_speed=gamevar("200", "The speed (or force) applied to the player when jumping")
	player_health=gamevar("100", "The health that the player has")
