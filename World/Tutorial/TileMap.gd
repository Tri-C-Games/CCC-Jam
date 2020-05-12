extends TileMap

func stack_tile(pos, width, height):
	var base_pos = world_to_map(pos)
	global.make_stack(self, width,height, base_pos)
