extends Node2D

var falling_tile = preload("res://Falling Tile/Falling Tile.tscn")

onready var player = get_node("Player")
onready var dialogue_box = player.get_node("HUD/Dialogue Box")

var received_first_dialogue = false

func _ready():
	randomize()

func _process(_delta):
	if not received_first_dialogue and player.position.x >= 1100:
		received_first_dialogue = true
		dialogue_box.buffer_dialogue("Hello, who are you? I haven't even finished making the game yet.")
		dialogue_box.buffer_dialogue("What are you saying? It's already on itch?")
		dialogue_box.buffer_dialogue("Oh crap, oh crap... Hey, I have an idea! My game isn't finished, can you finish it for me?")
		dialogue_box.start_dialogue()
		
		yield(dialogue_box, "finished")
		
		for i in range(global.random_int(8, 12)):
			create_falling_tile($"Falling Tile Pos".position - Vector2(0, 80*i), global.random_int(2, 5), global.random_int(10,20))

func create_falling_tile(pos, width, height):
	var falling_tile_instance = falling_tile.instance()
	falling_tile_instance.position = pos
	falling_tile_instance.set_width(width,height)
	$"Falling Tiles".add_child(falling_tile_instance)
