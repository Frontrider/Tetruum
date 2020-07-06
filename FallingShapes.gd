extends TileMap

signal fallen(positions)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_size = Vector2(12,18)
export(NodePath) var StaticMap

var static_map

var movement = 0

var shape
var shape_index
var top_left

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	static_map = get_node(StaticMap)

	pass # Replace with function body.

var currently_moving = []

func tick():
	move_cells_by(0,1)
	pass
	
func reset():
	clear()

	pass
	

func move_cells_by(x,y):
	var used_cells = get_used_cells()
	
	if used_cells.empty():
		return
		
	var vertical_move = []
	var horizontal_move = []
	
	for cell in used_cells:
		vertical_move.append(Vector2(cell.x,cell.y+y))
		horizontal_move.append(Vector2(cell.x+x,cell.y))
		pass
		
	var blocked_horizontal = false
	var blocked_vertical = false
	
	for target in vertical_move:
		var target_cell = static_map.get_cellv(target)
		if target_cell != -1:
			blocked_vertical = true
	
	for target in horizontal_move:
		var target_cell = static_map.get_cellv(target)
		if target_cell != -1:
			blocked_horizontal = true
			
		
	if blocked_vertical:
		for cell in used_cells:
			static_map.set_cellv(cell,get_cellv(cell))
			set_cellv(cell,-1)
		emit_signal("fallen",used_cells)
		pass
	elif y != 0:
		if top_left != null:
			top_left.y = top_left.y+y
		var cell_id = -1
		for cell in used_cells:
			cell_id = get_cellv(cell)
			set_cellv(cell,-1)
		for cell in vertical_move:
			set_cellv(cell,cell_id)

	#we don't set the shape if it can still fall.
	if blocked_horizontal:
		pass
	elif x !=0:
		if top_left != null:
			top_left.x = top_left.x+x
		var cell_id = -1
		for cell in used_cells:
			cell_id = get_cellv(cell)
			set_cellv(cell,-1)
		for cell in horizontal_move:
			set_cellv(cell,cell_id)
	pass


