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

const MIN_LEAF_SIZE: int = 10      # minimum size of a BSP region
const MAX_DEPTH: int = 4           # how many times to split
const MIN_ROOM_SIZE: int = 4       # minimum width/height of a room

const FLOOR_TILE: int = TILE_TYPES.DIRT
const WALL_TILE: int = TILE_TYPES.STONE

var _leaf_regions: Array[Rect2i] = []   # final BSP leaves
var _rooms: Array[Rect2i] = []          # carved room rectangles
var _room_centers: Array[Vector2i] = [] # centers of rooms (for corridors)


func _init(w: int, h: int) -> void:
	width = w
	height = h
	grid = LevelGrid.new()
	generate_grid()


func get_grid() -> LevelGrid:
	return grid


func generate_grid() -> void:
	# 1) Start with solid WALL everywhere
	grid = LevelGrid.new()
	for y in height:
		for x in width:
			grid.add_tile(Vector2i(x, y), WALL_TILE)

	# 2) Build BSP
	_leaf_regions.clear()
	_rooms.clear()
	_room_centers.clear()

	var root_rect := Rect2i(Vector2i(0, 0), Vector2i(width, height))
	_split_region(root_rect, 0)

	# 3) Carve a room in each leaf
	for region in _leaf_regions:
		var room := _create_room_in_leaf(region)
		if room.size.x > 0 and room.size.y > 0:
			_rooms.append(room)
			var center := _rect_center(room)
			_room_centers.append(center)
			_carve_room(room)

	# 4) Connect rooms with corridors
	if _room_centers.size() >= 2:
		for i in range(1, _room_centers.size()):
			_carve_corridor(_room_centers[i - 1], _room_centers[i])


# ---------- BSP SPLITTING ----------

func _split_region(region: Rect2i, depth: int) -> void:
	var can_split_h := region.size.y >= MIN_LEAF_SIZE * 2
	var can_split_v := region.size.x >= MIN_LEAF_SIZE * 2

	if depth >= MAX_DEPTH or (not can_split_h and not can_split_v):
		_leaf_regions.append(region)
		return

	var split_horiz: bool
	if can_split_h and can_split_v:
		split_horiz = (randi() % 2) == 0
	else:
		split_horiz = can_split_h

	if split_horiz:
		# horizontal split (top/bottom)
		var min_y := region.position.y + MIN_LEAF_SIZE
		var max_y := region.position.y + region.size.y - MIN_LEAF_SIZE
		if min_y >= max_y:
			_leaf_regions.append(region)
			return
		var split_y := randi_range(min_y, max_y)

		var top_rect := Rect2i(
			region.position,
			Vector2i(region.size.x, split_y - region.position.y)
		)

		var bottom_rect := Rect2i(
			Vector2i(region.position.x, split_y),
			Vector2i(region.size.x, region.position.y + region.size.y - split_y)
		)

		_split_region(top_rect, depth + 1)
		_split_region(bottom_rect, depth + 1)
	else:
		# vertical split (left/right)
		var min_x := region.position.x + MIN_LEAF_SIZE
		var max_x := region.position.x + region.size.x - MIN_LEAF_SIZE
		if min_x >= max_x:
			_leaf_regions.append(region)
			return
		var split_x := randi_range(min_x, max_x)

		var left_rect := Rect2i(
			region.position,
			Vector2i(split_x - region.position.x, region.size.y)
		)

		var right_rect := Rect2i(
			Vector2i(split_x, region.position.y),
			Vector2i(region.position.x + region.size.x - split_x, region.size.y)
		)

		_split_region(left_rect, depth + 1)
		_split_region(right_rect, depth + 1)


# ---------- ROOMS ----------

func _create_room_in_leaf(region: Rect2i) -> Rect2i:
	# max possible room size inside region (leave 1 tile margin)
	var max_w := region.size.x - 2
	var max_h := region.size.y - 2

	if max_w < MIN_ROOM_SIZE or max_h < MIN_ROOM_SIZE:
		return Rect2i(region.position, Vector2i(0, 0)) # invalid

	var room_w := randi_range(MIN_ROOM_SIZE, max_w)
	var room_h := randi_range(MIN_ROOM_SIZE, max_h)

	var min_x := region.position.x + 1
	var max_x := region.position.x + region.size.x - room_w - 1
	var min_y := region.position.y + 1
	var max_y := region.position.y + region.size.y - room_h - 1

	var room_x := randi_range(min_x, max_x)
	var room_y := randi_range(min_y, max_y)

	return Rect2i(Vector2i(room_x, room_y), Vector2i(room_w, room_h))


func _carve_room(room: Rect2i) -> void:
	for y in range(room.position.y, room.position.y + room.size.y):
		for x in range(room.position.x, room.position.x + room.size.x):
			grid.add_tile(Vector2i(x, y), FLOOR_TILE)


func _rect_center(rect: Rect2i) -> Vector2i:
	var cx := rect.position.x + rect.size.x / 2
	var cy := rect.position.y + rect.size.y / 2
	return Vector2i(cx, cy)


# ---------- CORRIDORS ----------

func _carve_corridor(from: Vector2i, to: Vector2i) -> void:
	var current := from

	# carve horizontal part
	while current.x != to.x:
		var step_x := 1 if to.x > current.x else -1
		current.x += step_x
		grid.add_tile(current, FLOOR_TILE)

	# carve vertical part
	while current.y != to.y:
		var step_y := 1 if to.y > current.y else -1
		current.y += step_y
		grid.add_tile(current, FLOOR_TILE)
