extends RigidBody2D
var tapped = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if not tapped:
		tapped = false
		$Tap.play()
		await get_tree().create_timer(0.05).timeout
		tapped = true
	
