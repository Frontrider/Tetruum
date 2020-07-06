extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_score(score)
	pass # Replace with function body.

func add_score(amount):
	score = score+amount
	set_score(score)

func set_score(score):
	
	text = str(score)+" Points"
	pass

func reset():
	set_score(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
