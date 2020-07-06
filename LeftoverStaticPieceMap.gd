extends "res://FallingShapes.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var added_cells = false

func tick():
	move_cells_by(0,1)
	pass

	
func _unhandled_input(event):
	if event.is_action_pressed("ui_down"):
		move_cells_by(0,1)
		return


func _on_LeftoverStaticPieceMap_fallen(positions):
	static_map.clear_under_shape()

	pass # Replace with function body.
