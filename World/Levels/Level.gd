extends Node2D

onready var player = get_node("Player")
onready var hud = player.get_node("HUD")
onready var dialogue_box = player.get_node("HUD/Dialogue Box")
onready var artifact_shader = GlobalScreenShaders.get_node("TextureRect").material

# The higher the value the less artifacts appear.
var artifact_frequencies = [
	1, # Tutorial - However, the tutorial has a separate code file anyway.
	1, # Level 2
	0.75, # Level 3
	0.75, # Level 4
	0.7, # Level 5
]

func _ready():
	if not global.can_open_console:
		hud.enable_open_console()
	
	global.upgrade(dialogue_box, global.level - 1, true)
	
	artifact_shader.set_shader_param("enabled", true)
	artifact_shader.set_shader_param("frequency", artifact_frequencies[int(name[-1]) - 1])
	
	if name[-1] == "3":
		dialogue_box.buffer_dialogue("You may notice some visual artifacts in the game which may or may not be due to my bad code.")
	dialogue_box.start_dialogue()
