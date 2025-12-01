class_name GenAlgorithm
extends RefCounted

var width: int
var height: int
var grid: LevelGrid

enum TILE_TYPES {
	GRASS,
	DIRT,
	STONE,
	OCEAN,
	LAKE,
	LAVA
}

func _init(w: int, h: int) -> void:
	width = w
	height = h
	grid = LevelGrid.new()
	generate_grid()

func get_grid() -> LevelGrid:
	return grid

func generate_grid() -> void:
	for y in height:
		for x in width:
			var coord := Vector2i(x, y)
			var tile_type := _pick_tile()
			grid.add_tile(coord, tile_type)

func _pick_tile() -> int:
	var r := randf()
	if r < 0.4: return TILE_TYPES.GRASS
	elif r < 0.6: return TILE_TYPES.DIRT
	elif r < 0.75: return TILE_TYPES.STONE
	elif r < 0.9: return TILE_TYPES.LAKE
	else: return TILE_TYPES.LAVA
