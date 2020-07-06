
extends "res://FallingShapes.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shape_count = 0;

onready var debug_map = $DebugMap
onready var shapes = $Shapes
var should_spawn = true
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	static_map = get_node(StaticMap)
	
	pass # Replace with function body.


func tick():
	if should_spawn:
		spawn_new_shape()
		should_spawn = false
	move_cells_by(0,1)
	debug_map.clear()
	debug_map.set_cellv(top_left,0)
	pass
	
func reset():
	shape_count =0
	clear()
	spawn_new_shape()
	pass

var cancel_left = false
var cancel_right = false
var cancel_down= false

func input_loop():
	if !cancel_left:
		if Input.is_action_pressed("ui_left"):
			move_cells_by(-1,0)
	else:
		cancel_left = false

	if !cancel_right:
		if Input.is_action_pressed("ui_right"):
			move_cells_by(1,0)
	else:
		cancel_right = false
		
	if !cancel_down:
		if Input.is_action_pressed("ui_down"):
			move_cells_by(0,1)
	else:
		cancel_down = false
	pass


func _unhandled_input(event):
	var movement = 0;
	if event.is_action_pressed("ui_left"):
		move_cells_by(-1,0)
		cancel_left = true
		return
		
	if event.is_action_pressed("ui_right"):
		move_cells_by(1,0)
		cancel_right = true
		return
	
	if event.is_action_pressed("ui_down"):
		move_cells_by(0,1)
		cancel_down = true
		return
	
	if event.is_action_pressed("change_shape"):
		change_shape()
		return

func change_shape():
	var new_index = shape.next_index(shape_index)
	var new_shape = shape.all_shapes[new_index]
	var new_cells = new_shape.get_used_cells()
	var id =  new_shape.get_cellv(new_cells[0])
	var local_cells = []
	
	var can_change = true
	for cell in new_cells:
		var local_cell = Vector2(cell.x+top_left.x,cell.y+top_left.y)
		local_cells.append(local_cell)
		
		var map_cell = static_map.get_cellv(local_cell)
		if map_cell != -1:
			can_change = false
		pass
	
	if can_change:
		for cell in shape.all_shapes[shape_index].get_used_cells():
			set_cell(cell.x+top_left.x,cell.y+top_left.y,-1)
		for cell in local_cells:
			set_cell(cell.x,cell.y,id)
		pass
		shape_index = new_index
	pass

func on_fallen(used_cells):
	should_spawn = true
	

func spawn_new_shape():
	var start_x = 2
	var curr_shape

	shape = shapes.all_shapes[randi()%shapes.all_shapes.size()]
	shape_index =randi()%shape.all_shapes.size()
	curr_shape = shape.all_shapes[shape_index]		
	 
	var cells = curr_shape.get_used_cells()
	top_left = Vector2(start_x,0)
	
	##this exists strictly for the bomb for now.

	for cell in cells:
		set_cell(start_x+cell.x,cell.y,curr_shape.get_cellv(cell))
	shape_count = shape_count +1
	pass

	
func remove(cell):
	for x in range(cell.x-2,cell.x-2):
		for y in range(cell.y-2,cell.y-2):
			static_map.set_cell(x,y,-1)
	
	pass
