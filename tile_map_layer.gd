extends TileMapLayer

@export var map_width: int = 32
@export var map_height: int = 32

# These match your tileset:
@export var grass_source_id: int = 0
@export var grass_coords: Vector2i = Vector2i(0, 0)

@export var dirt_source_id: int = 0
@export var dirt_coords: Vector2i = Vector2i(1, 0)

@export var stone_source_id: int = 0
@export var stone_coords: Vector2i = Vector2i(2, 0)

@export var lake_source_id: int = 0
@export var lake_coords: Vector2i = Vector2i(3, 0)

@export var lava_source_id: int = 0
@export var lava_coords: Vector2i = Vector2i(4, 0)

var gen: GenAlgorithm

func _ready() -> void:
	print("TileMapLayer READY. Drawing hard-test tile...")

	# Hard test: draw ONE TILE to confirm rendering works
	clear()
	set_cell(Vector2i(0, 0), grass_source_id, grass_coords)

	# If this tile appears, the generator will work too.
	randomize()
	gen = GenAlgorithm.new(map_width, map_height)
	draw_from_grid()

func draw_from_grid() -> void:
	print("TileMapLayer: drawing grid…")
	clear()

	var level_grid := gen.get_grid()
	var coords := level_grid.get_all_coords()

	print("Total coords:", coords.size())

	for coord in coords:
		var tile_type := level_grid.get_tile(coord)

		match tile_type:
			GenAlgorithm.TILE_TYPES.GRASS:
				set_cell(coord, grass_source_id, grass_coords)
			GenAlgorithm.TILE_TYPES.DIRT:
				set_cell(coord, dirt_source_id, dirt_coords)
			GenAlgorithm.TILE_TYPES.STONE:
				set_cell(coord, stone_source_id, stone_coords)
			GenAlgorithm.TILE_TYPES.LAKE:
				set_cell(coord, lake_source_id, lake_coords)
			GenAlgorithm.TILE_TYPES.LAVA:
				set_cell(coord, lava_source_id, lava_coords)
			_:
				pass

	print("TileMapLayer DONE")
