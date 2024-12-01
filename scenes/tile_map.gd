extends TileMap

const WALL_TILE = Vector2i(0, 0)
const PATH_TILE = Vector2i(1, 0)
const NORTH = Vector2i(0, -1)
const SOUTH = Vector2i(0, 1)
const EAST = Vector2i(1, 0)
const WEST = Vector2i(-1, 0)
var DIRECTIONS = [NORTH, SOUTH, EAST, WEST]

@onready var player = get_parent().get_node("maze_cursor")
@onready var goal = get_parent().get_node("Goal")
@export var maze_width: int = 21
@export var maze_height: int = 21

var start_pos: Vector2i
var end_pos: Vector2i
var tile_size: Vector2

func _ready():
	randomize()
	assert(player != null, "Player node not found!")
	assert(goal != null, "Goal node not found!")
	
	# Get tile size from TileMap
	tile_size = get_tileset().get_tile_size()
	
	generate_maze()
	place_player_and_goal()

func generate_maze():
	maze_width = maze_width if maze_width % 2 == 1 else maze_width + 1
	maze_height = maze_height if maze_height % 2 == 1 else maze_height + 1
	
	for x in range(maze_width):
		for y in range(maze_height):
			set_cell(0, Vector2i(x, y), 0, WALL_TILE)
	
	start_pos = Vector2i(1, 1)
	var visited = {}
	var stack = [start_pos]
	visited[start_pos] = true
	set_cell(0, start_pos, 0, PATH_TILE)
	
	var max_depth = 0
	end_pos = start_pos
	
	while stack.size() > 0:
		var current = stack.back()
		var unvisited = []
		
		for dir in DIRECTIONS:
			var next = current + (dir * 2)
			if is_valid_cell(next) and not visited.has(next):
				unvisited.append([next, dir])
		
		if unvisited.size() > 0:
			var choice = unvisited[randi() % unvisited.size()]
			var next_cell = choice[0]
			var direction = choice[1]
			
			var between_cell = current + direction
			set_cell(0, between_cell, 0, PATH_TILE)
			set_cell(0, next_cell, 0, PATH_TILE)
			
			visited[next_cell] = true
			stack.push_back(next_cell)
			
			if stack.size() > max_depth:
				max_depth = stack.size()
				end_pos = next_cell
		else:
			stack.pop_back()

func is_valid_cell(pos: Vector2i) -> bool:
	return pos.x > 0 and pos.x < maze_width - 1 and \
		   pos.y > 0 and pos.y < maze_height - 1

func place_player_and_goal():
	# Convert tile positions to world positions considering TileMap's transform
	var world_transform = get_global_transform()
	var player_world_pos = world_transform * (map_to_local(start_pos))
	var goal_world_pos = world_transform * (map_to_local(end_pos))
	
	# Set player position
	player.global_position = player_world_pos
	
	# Set goal position and size relative to tile size
	goal.size = tile_size
	goal.global_position = goal_world_pos - goal.size / 2
	goal.color = Color(0, 1, 0, 0.5)

func is_wall_at_position(world_pos: Vector2) -> bool:
	var tile_pos = local_to_map(to_local(world_pos))
	return get_cell_atlas_coords(0, tile_pos) == WALL_TILE

func get_tile_pos_from_world(world_pos: Vector2) -> Vector2i:
	return local_to_map(to_local(world_pos))
