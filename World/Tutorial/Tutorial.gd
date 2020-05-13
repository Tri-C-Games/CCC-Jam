extends Node2D

var falling_tile = preload("res://Falling Tile/Falling Tile.tscn")

onready var player = get_node("Player")
onready var hud = player.get_node("HUD")
onready var dialogue_box = player.get_node("HUD/Dialogue Box")
onready var tilemap = get_node("TileMap")

var received_first_dialogue = false
var after_tower_first = false

const falling_tile_y_pos = 100

func _ready():
	randomize()

func _process(_delta):
	if not received_first_dialogue and player.position.x >= 1100:
		received_first_dialogue = true
		
		dialogue_box.buffer_dialogue("Hello, who are you? I haven't finished making the game yet.")
		dialogue_box.buffer_dialogue("What are you saying? It's already on itch?")
		dialogue_box.buffer_dialogue("Oh crap, oh crap... Hey, I have an idea! Can you finish my game for me?")
		dialogue_box.start_dialogue()
		
		yield(dialogue_box, "finished")
		
		var height = global.random_int(8, 12)
		var pos = Vector2(stepify(player.position.x, 64) + 384, stepify(player.position.y, 64) - (height + 2) * 32)
		for i in range(height):
			create_falling_tile(pos - Vector2(0, 80*i), global.random_int(2, 5))
		
		yield(tilemap, "tiles_stacked")
		dialogue_box.buffer_dialogue("Hmmm... That's not supposed to happen. You can probably jump over this if you use the developer console. [color=red]Click the button in the top right or press ESC.[/color]")
		dialogue_box.start_dialogue()
		
		after_tower_first = true
		
		hud.enable_open_console()
	
	if after_tower_first and player.position.x >= 2900:
		after_tower_first = false
		
		dialogue_box.buffer_dialogue("Hurry up and get up there already!")
		dialogue_box.start_dialogue()

func create_falling_tile(pos, width):
	var falling_tile_instance = falling_tile.instance()
	falling_tile_instance.position = pos
	falling_tile_instance.set_width(width)
	$"Falling Tiles".add_child(falling_tile_instance)

func _on_Coin_body_entered(_body):
	global.go_to_next_level()
