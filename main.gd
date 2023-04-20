extends Node2D
var plinko = preload("res://plinko.tscn")
var doneitem = preload("res://done_item.tscn")
var todoitem = preload("res://todo_item.tscn")
var late = preload("res://art/2_1.png")
var done = preload("res://art/3.png")
var miss = preload("res://art/4.png")
var rng = RandomNumberGenerator.new()
var activities = ["study", "hobby", "errand", "social", "work"]
var celltext = ["work", "hobby", "?????", "study", "freeze", "errand", "social"]
var plinko_count = 7
var todo_comp = []
var done_comp = []
var drop = false
var gen = false
var dayended = false
var plinkosdone = false
var onetime_plinkosdone = false
var c_miss = Color(239, 157, 101)
var c_late = Color(193, 202, 121)
var c_done = Color(130, 173, 104)
@onready var todo_list = $Todo_List/V
@onready var done_list = $Done_List/V


# Called when the node enters the scene tree for the first time.
func _ready():
	# generate new todo_list
	for i in range(0, 7):
		var act_index = rng.randf_range(0, activities.size())
		var instance = todoitem.instantiate()
		instance.activity = activities[act_index]
		todo_list.add_child(instance)
		todo_comp.append(activities[act_index])
	
	# generate cells
	for i in range(7):
		var current_cell = $Cells.get_child(i)
		current_cell.activity = celltext[i]
		
		current_cell.get_node("L/Label").text = celltext[i]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drop:
		$Preview.global_position.x = get_global_mouse_position().x
	if Input.is_action_just_pressed("Click"):
		if plinko_count and drop:
			var instance = plinko.instantiate()
			add_child(instance)
			instance.position = Vector2(get_global_mouse_position().x, 80)

			plinko_count -= 1
		else:  # if plinkos are out
			pass
#			print("aaaaaa")
#			print(todo_comp.size())
#			print(done_comp.size())
#			if todo_comp.size() == done_comp.size():
#				print("no plinkos left")
#				print(todo_comp)
#				print(done_comp)
				
				
	if not plinko_count:
		if plinkosdone:
			if todo_comp.size() == done_comp.size():
				plinkosdone = false
				await get_tree().create_timer(2).timeout
				dayended = true
			
		
	if dayended:
		dayended = false	
		#print(todo_comp)
		#print(done_comp)
		var todo_comp_left = todo_comp.duplicate()
		for i in range(todo_comp.size()):
			if todo_comp[i] == done_comp[i]:
				done_list.get_children()[i].change_color(done)
				print("a")
			elif done_comp[i] in todo_comp_left:
				done_list.get_children()[i].change_color(late)
				todo_comp_left.erase(str(done_comp[i]))
				print("b")
			else:
				done_list.get_children()[i].change_color(miss)
				print("c")
			print(i, " todo: ", todo_comp)
			print(i, " left: ", todo_comp_left)
			print(i, " done: ", done_comp)
		
			


func _on_cell_landed(activity):
	if not gen:
		var instance = doneitem.instantiate()
		instance.activity = activity
		done_list.add_child(instance)
		done_comp.append(activity)
		
	pass


func _on_mouse_area_mouse_entered():
	drop = true

func _on_mouse_area_mouse_exited():
	drop = false


func _on_generate_pressed():
	
	gen = true 
	todo_comp = []
	done_comp = []
	
	for child in self.get_children():
		if child.is_in_group("plinkos"): child.queue_free()
	
	for child in todo_list.get_children():
		child.queue_free()
	for child in done_list.get_children():
		child.queue_free()
	
	plinkosdone = false
	onetime_plinkosdone = false
	dayended = false
	plinko_count = 7
	drop = false
	
	for i in range(0, 7):
		var act_index = rng.randf_range(0, activities.size())
		var instance = todoitem.instantiate()
		instance.activity = activities[act_index]
		todo_list.add_child(instance)
		todo_comp.append(activities[act_index])
		
	await get_tree().create_timer(2).timeout
	gen = false
