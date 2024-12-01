extends Node2D

@export var width: int = 20
@export var height: int = 20
@export var cell_size: int = 32

# Cell class to store wall states
class Cell:
	var walls = {
		"north": true,
		"south": true,
		"east": true,
		"west": true
	}
	var visited = false
	var x: int
	var y: int
	
	func _init(pos_x: int, pos_y: int):
		x = pos_x
		y = pos_y

# Grid to store cells
var grid: Array = []
var current_cell: Cell
var stack: Array = []

func _ready():
	initialize_grid()
	generate_maze()
	queue_redraw()

func initialize_grid():
	# Create the grid of cells
	for x in range(width):
		grid.append([])
		for y in range(height):
			grid[x].append(Cell.new(x, y))
	
	# Start from top-left cell
	current_cell = grid[0][0]
	current_cell.visited = true

func get_unvisited_neighbors(cell: Cell) -> Array:
	var neighbors = []
	
	# Check all four directions
	var directions = [
		{"x": 0, "y": -1, "wall": "north", "opposite": "south"},  # North
		{"x": 1, "y": 0, "wall": "east", "opposite": "west"},    # East
		{"x": 0, "y": 1, "wall": "south", "opposite": "north"},  # South
		{"x": -1, "y": 0, "wall": "west", "opposite": "east"}    # West
	]
	
	for dir in directions:
		var new_x = cell.x + dir.x
		var new_y = cell.y + dir.y
		
		if new_x >= 0 and new_x < width and new_y >= 0 and new_y < height:
			var neighbor = grid[new_x][new_y]
			if not neighbor.visited:
				dir["cell"] = neighbor
				neighbors.append(dir)
	
	return neighbors

func generate_maze():
	while true:
		var neighbors = get_unvisited_neighbors(current_cell)
		
		if neighbors.size() > 0:
			# Choose random neighbor
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current_cell)
			
			# Remove walls between current cell and chosen neighbor
			current_cell.walls[next.wall] = false
			next.cell.walls[next.opposite] = false
			
			# Move to next cell
			current_cell = next.cell
			current_cell.visited = true
		elif stack.size() > 0:
			current_cell = stack.pop_back()
		else:
			break

func _draw():
	for x in range(width):
		for y in range(height):
			var cell = grid[x][y]
			var pos_x = x * cell_size
			var pos_y = y * cell_size
			
			if cell.walls.north:
				draw_line(Vector2(pos_x, pos_y), 
						 Vector2(pos_x + cell_size, pos_y),
						 Color.WHITE)
			
			if cell.walls.east:
				draw_line(Vector2(pos_x + cell_size, pos_y),
						 Vector2(pos_x + cell_size, pos_y + cell_size),
						 Color.WHITE)
			
			if cell.walls.south:
				draw_line(Vector2(pos_x, pos_y + cell_size),
						 Vector2(pos_x + cell_size, pos_y + cell_size),
						 Color.WHITE)
			
			if cell.walls.west:
				draw_line(Vector2(pos_x, pos_y),
						 Vector2(pos_x, pos_y + cell_size),
						 Color.WHITE)
