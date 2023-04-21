extends Node2D
@export var activity: String 
signal landed

# Called when the node enters the scene tree for the first time.
func _ready():
	$L/Label.text = activity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("plinkos"):
		await get_tree().create_timer(1.5).timeout
		if is_instance_valid(body):
			emit_signal("landed", activity)
			body.queue_free()
			if not $"../../".plinko_count and not $"../../".onetime_plinkosdone:
				$"../../".onetime_plinkosdone = true
				await get_tree().create_timer(2).timeout
				$"../../".plinkosdone = true
		
