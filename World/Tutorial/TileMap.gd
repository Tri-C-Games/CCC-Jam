extends TileMap

func stack_tile(pos, width):
	var base_pos = world_to_map(pos)
	for i in range(width):
		var final_pos = base_pos + Vector2(i, 0)
		if i == 0 and width == 1:
			set_cellv(final_pos, global.tiles.TILE_SOLO)
		else:
			if i == 0:
				set_cellv(final_pos, global.tiles.TILE_LEFT)
			elif i == width - 1:
				set_cellv(final_pos, global.tiles.TILE_RIGHT)
			else:
				set_cellv(final_pos, global.tiles.TILE_MIDDLE)
