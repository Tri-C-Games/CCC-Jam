extends TileMap

enum tiles {
	TILE_LEFT = 1,
	TILE_MIDDLE = 2,
	TILE_RIGHT = 3,
	TILE_SOLO = 6
}

func set_width(width):
	for i in range(width):
		if i == 0 and width == 1:
			set_cellv(Vector2(i, 0), tiles.TILE_SOLO)
		else:
			if i == 0:
				set_cellv(Vector2(i, 0), tiles.TILE_LEFT)
			elif i == width - 1:
				set_cellv(Vector2(i, 0), tiles.TILE_RIGHT)
			else:
				set_cellv(Vector2(i, 0), tiles.TILE_MIDDLE)
