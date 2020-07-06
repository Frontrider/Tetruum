extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var StaticMap
export var action =""
var static_map

# Called when the node enters the scene tree for the first time.
func _ready():
	static_map = get_node(StaticMap)
	connect("pressed",self,"pressed")
	pass # Replace with function body.

func pressed():
	static_map.call(action)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
