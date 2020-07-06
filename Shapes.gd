extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var all_shapes = []
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		all_shapes.append(child)
	
	pass # Replace with function body.

func next_index(index):
	if index >= all_shapes.size()-1:
		return 0
	else:
		return index+1
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
