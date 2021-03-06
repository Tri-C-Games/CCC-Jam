extends Node2D

var falling_tile = preload("res://Falling Tile/Falling Tile.tscn")

onready var player = get_node("Player")
onready var hud = player.get_node("HUD")
onready var dialogue_box = player.get_node("HUD/Dialogue Box")
onready var tilemap = get_node("TileMap")
onready var FallZone = get_node("FallZone").position
onready var falling_tile_support_pos = get_node("Falling Tile Support").position
onready var barrier_pos = get_node("Barrier").position

var received_first_dialogue = false
var after_tower_first = false

const falling_tile_y_pos = 100

func _ready():
	randomize()
	
	if global.can_open_console:
		hud.enable_open_console()

func _process(_delta):
	if not received_first_dialogue and player.position.x >= 1100:
		received_first_dialogue = true
		
		dialogue_box.buffer_dialogue("Hey! Who are you? What are you doing here? I haven't finished making the game yet.")
		dialogue_box.buffer_dialogue("What are you saying? It's already on itch?")
		dialogue_box.buffer_dialogue("OH CRAP THIS IS BAD... Hey, I have an idea! Can you finish the game for me?")
		dialogue_box.start_dialogue()
		
		yield(dialogue_box, "finished")
		
		var height = 12
		var pos = FallZone
		for i in range(height):
			create_falling_tile(pos - Vector2(0, 80*i), 4)
		var support_pos = tilemap.world_to_map(falling_tile_support_pos)
		tilemap.set_cellv(support_pos, global.tiles.TILE_LEFT)
		for i in range(4):
			tilemap.set_cellv(support_pos + Vector2(i + 1, 0), global.tiles.TILE_MIDDLE)
		tilemap.set_cellv(support_pos + Vector2(5, 0), global.tiles.TILE_RIGHT)
		
		yield(tilemap, "tiles_stacked")
		dialogue_box.buffer_dialogue("Hmmm... That's not supposed to happen. You can probably jump over this if you use the developer console. [color=red]Click the button in the top right or press ESC.[/color]")
		global.upgrade(dialogue_box, 0)
		dialogue_box.start_dialogue()
		
		hud.enable_open_console()
		
		yield(dialogue_box, "finished")
		
		var p = tilemap.world_to_map(barrier_pos)
		tilemap.set_cellv(p, -1)
		for i in range(1, 5):
			tilemap.set_cellv(p + Vector2(0, i), -1)
		
		after_tower_first = true
	
	if after_tower_first and player.position.x >= 2900:
		after_tower_first = false
		
		dialogue_box.buffer_dialogue("Hurry up and get up there!")
		dialogue_box.start_dialogue()

func create_falling_tile(pos, width):
	var falling_tile_instance = falling_tile.instance()
	falling_tile_instance.position = pos
	falling_tile_instance.set_width(width)
	$"Falling Tiles".add_child(falling_tile_instance)
