class_name GenAlgorithm

extends RefCounted

var width:int
var height:int

var grid:LevelGrid

enum TILE_TYPES {
	GRASS,
	DIRT,
	STONE,
	OCEAN,
	LAKE,
	LAVA
}

func _init(w:int, h:int) -> void:
	width = w
	height = h
	
	grid = LevelGrid.new()
	
	generate_grid()

func get_grid() -> LevelGrid:
	return grid
	
func generate_grid() -> void:
	pass
