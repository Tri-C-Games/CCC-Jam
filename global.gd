extends Node

# All variables in here will be changeable in the console.
class gamevar:
	var value:String
	var description:String
	var writable: bool=true
	
func gamevar(var value:String="", var description:String="", var writable:bool=true):
	var variable=gamevar.new
	variable.value=value
	variable.description=description
	variable.writable=writable
	variable.writable=writable
	return variable
# General
# Movement
#var gravity = "500"
#var player_fly = "false"
#var player_max_speed = "600"
#var player_max_acc = "70"
#var player_max_friction = "60"
#var player_jump_speed = "200"
#var player_health = "100"
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
	
