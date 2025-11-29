extends TileMapLayer

@export var tile_source_id: int = 0 # The ID of the TileSetSource you want to use
@export var atlas_coords: Vector2i = Vector2i(0, 0) # The atlas coordinates of the tile within the source

func _ready():
	# Example: Place a single tile at map coordinates (5, 5)
	place_tile(Vector2i(5, 5))

	# Example: Fill a rectangular area with tiles
	fill_area(Vector2i(0, 0), Vector2i(10, 10))

func place_tile(map_coords: Vector2i):
	# Set a single tile at the given map coordinates
	set_cell(map_coords, tile_source_id, atlas_coords)

func fill_area(start_coords: Vector2i, end_coords: Vector2i):
	# Fill a rectangular area with tiles
	for x in range(start_coords.x, end_coords.x + 1):
		for y in range(start_coords.y, end_coords.y + 1):
			set_cell(Vector2i(x, y), tile_source_id, atlas_coords)
