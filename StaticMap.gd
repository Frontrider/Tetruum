extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_size = Vector2(12,18)

onready var shapes = $Templates
onready var overlay = $ShapeOverlay
onready var leftover_map = $LeftoverStaticPieceMap
onready var frame = $Frame
export(NodePath) var FallingMap
export(NodePath) var Score

var score_handler 
var falling_map

var selected_shape
var required_number_of_cells = 0
var empty_cell_count = 0;
var is_first = true
var cleared_map = false
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	score_handler = get_node(Score)
	falling_map = get_node(FallingMap)

	select_shape()
	pass # Replace with function body.

func tick():
	select_shape()
	fix_invalid_tiles()
	update_dirty_quadrants()
	var used_cells = get_cells()
	var failed = false
	for cell in used_cells:
		if cell.y == 0:
			failed = true
	
	if failed:
		reset()
		falling_map.reset()
	pass
	
	update_overlay(used_cells)
	erase_rows(used_cells)
	pass

func get_cells():
	var used_cells = []
	var rect = self.get_used_rect()
	for x in range(1,14):
		for y in range(19):
			var cell_id = get_cell(x,y)
			if cell_id != 1 and cell_id != -1:
				used_cells.append(Vector2(x,y))
		pass
	return used_cells
	pass

func erase_rows(used_cells):
	var cells_in_shape = selected_shape.get_used_cells()
	
	var win = false
	var cell_count = 0
	var empty_count =0
	for cell in cells_in_shape:
		var id = selected_shape.get_cellv(cell)
		if id == 1:
			var has_cell = used_cells.has(cell)
			win = has_cell
			if has_cell:
				cell_count = cell_count +1
			pass
		if id == 2:
			var cell_missing = !used_cells.has(cell)
			win = cell_missing
			if cell_missing:
				empty_count = empty_count+1
			pass
		pass
	
	
	var cleared_y = []
	
	if win and (cell_count == required_number_of_cells) and (empty_count == empty_cell_count):
		for cell in cells_in_shape:
			var y = cell.y
			if !cleared_y.has(y):
				for x in range(1,max_size.x):
					set_cell(x,y,-1)
					score_handler.add_score(10)
					pass
				pass
			else:
				cleared_y.append(y)
		selected_shape = null;
		pass


	make_fall()
	pass
	
func make_fall():
	#make everything fall.
	var leftower_cells = get_used_cells()
	for cell in leftower_cells:
		var id = get_cellv(cell)
		if id != 1:
			leftover_map.set_cellv(cell,get_cellv(cell))
			set_cellv(cell,-1)
	
	leftover_map.added_cells = true
	pass

func update_overlay(used_cells):
	
	var cells_in_shape = selected_shape.get_used_cells()
	
	for cell in cells_in_shape:
		var id = selected_shape.get_cellv(cell)
		if id == 2:
			if !used_cells.has(cell):
				overlay.set_cellv(cell,2)
			else:
				overlay.set_cellv(cell,1)
		if id == 1:
			if used_cells.has(cell):
				overlay.set_cellv(cell,2)
			else:
				overlay.set_cellv(cell,1)
				
	pass

func _unhandled_input(event):
	if event.is_action_released("reset"):
		reset_action()
		return
	if event.is_action_pressed("clear_shape"):
		clear_single()
		pass

func reset_action():
	if score_handler.score>10000:
		reset()
		falling_map.reset()
		score_handler.add_score(-10000)

func select_shape():
	if selected_shape == null:
		overlay.clear()
		make_fall()
		if is_first:
			selected_shape = shapes.all_shapes[randi()%2]
			is_first = false
		else:
			selected_shape = shapes.all_shapes[randi()%shapes.all_shapes.size()]

		
	required_number_of_cells = 0
	empty_cell_count = 0;
	var used_cells = selected_shape.get_used_cells()

	for cell in used_cells:
		var id = selected_shape.get_cellv(cell)
		overlay.set_cellv(cell,id)
		if id == 1:
			required_number_of_cells = required_number_of_cells+1
		if id == 2:
			empty_cell_count = empty_cell_count+1
		pass
	
	pass
	
func reset():
	self.clear()
	var base_cells =frame.get_used_cells()
	for cell in base_cells:
		set_cellv(cell,frame.get_cellv(cell))
	
	selected_shape = null;
	overlay.clear()
	select_shape()
	
func clear_single():
	if score_handler.score < 1000:
		return
	clear_under_shape()
	
func clear_under_shape():
	if selected_shape == null:
		select_shape()
	
	var cells = get_cells()
	var used_cells = selected_shape.get_used_cells()

	for cell in used_cells:
		var id = selected_shape.get_cellv(cell)
		if id == 2:
			set_cellv(cell,-1)
			pass
	pass
