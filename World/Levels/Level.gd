extends Node2D

onready var player = get_node("Player")
onready var hud = player.get_node("HUD")
onready var dialogue_box = player.get_node("HUD/Dialogue Box")

func _ready():
	if not global.can_open_console:
		hud.enable_open_console()
	
	global.upgrade(dialogue_box, global.level - 1)
	dialogue_box.start_dialogue()
