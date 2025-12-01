class_name LevelGrid
extends RefCounted

var grid: Dictionary[Vector2i, int] = {}
var changed_tiles: Array[Vector2i] = []

func _init() -> void:
	grid.clear()
	changed_tiles.clear()

func add_tile(coord: Vector2i, value: int) -> void:
	grid[coord] = value
	if not changed_tiles.has(coord):
		changed_tiles.append(coord)

func clear_tile(coord: Vector2i) -> void:
	if grid.has(coord):
		grid.erase(coord)
	if not changed_tiles.has(coord):
		changed_tiles.append(coord)

func get_tile(coord: Vector2i) -> int:
	if grid.has(coord):
		return grid[coord]
	return -1

func get_all_coords() -> Array[Vector2i]:
	return grid.keys()

func get_changed_coords() -> Array[Vector2i]:
	return changed_tiles

func clear_changed() -> void:
	changed_tiles.clear()
