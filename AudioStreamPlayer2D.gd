extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tracks = [
	preload("res://assets/Audio/Casual Arcade Track #1 (looped).wav"),
	preload("res://assets/Audio/Casual Arcade Track #3 (looped).wav")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	stream = tracks[randi()%2]
	play()
	pass # Replace with function body.




func _on_Music_finished():
	play()
	pass # Replace with function body.
