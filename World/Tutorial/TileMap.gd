extends TileMap

func stack_tile(pos, width):
	var base_pos = world_to_map(pos)
	global.place_tiles(self, width, base_pos)
