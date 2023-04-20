extends Control
var activity = ""
var c_state = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = activity
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func change_color(color):
	$Sprite2D.texture = color
