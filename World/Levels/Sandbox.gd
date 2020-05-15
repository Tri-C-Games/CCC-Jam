extends Node2D

onready var player = get_node("Player")
onready var hud = player.get_node("HUD")
onready var dialogue_box = hud.get_node("Dialogue Box")

func _ready():
	if not global.can_open_console:
		hud.enable_open_console()
	
	global.unlock_all_vars()
	
	dialogue_box.buffer_dialogue("I have unlocked a lot more variables for you to use! Be warned though, as some variables are very experimental.")
	dialogue_box.start_dialogue()
