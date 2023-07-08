class_name Grid extends Node2D

@export
var SIZE = 126

# internal data
var data : Array[Case] = []

var size_x = 0
var size_y = 0

signal case_clicked(x : int, y : int)
signal case_entered(x : int, y : int)
signal case_exited(x : int, y : int)

func resize(x, y):
	for elt in data:
		elt.queue_free()
	data.clear()

	size_x = x
	size_y = y

	for i in range(0, x):
		for j in range(0, y):
			var node = preload("res://scene/grid/Case.tscn").instantiate()
			add_child(node)
			node.position = Vector2(i*SIZE, j*SIZE)
			node.area.input_event.connect(click.bind(i,j))
			node.area.mouse_entered.connect(entered.bind(i,j))
			node.area.mouse_exited.connect(exited.bind(i,j))
			node.set_empty(true)
			data.push_back(node)

func get_elt(x, y) -> Case:
	return data[x*size_y + y]

func decrease_timer():
	for elt in data:
		elt.decrease_timer()

func click(_viewport, event, _shape_idx, i ,j):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		case_clicked.emit(i, j)

func entered(i ,j):
	case_entered.emit(i, j)

func exited(i ,j):
	case_exited.emit(i, j)

func check_all_case_on_fire() -> bool:
	for elt in data:
		if not elt.empty and not elt.is_tree and not elt.in_flame:
			return false
	return true

func get_nb_case_on_fire() -> int:
	var nb : int = 0
	for elt in data:
		if not elt.empty and elt.in_flame:
			nb += 1
	return nb

func has_trees() -> bool:
	for elt in data:
		if not elt.empty and elt.is_tree:
			return true
	return false

func tree_on_fire() -> bool:
	for elt in data:
		if not elt.empty and elt.is_tree and elt.in_flame:
			return true
	return false

func check_cats_on_tree() -> bool:
	for elt in data:
		if not elt.empty and elt.is_tree and not elt.cat_placed:
			return false
	return true

func place_cats():
	for elt in data:
		if not elt.empty and elt.is_tree:
			elt.place_cat()

func reset_all_markers():
	for elt in data:
		elt.touched.hide()

func serialize_grid() -> String:
	var ser : String = ""
	for elt in data:
		if elt.empty:
			ser += "0"
		else:
			ser += String.num_int64(elt.prefab_idx+1)
	return ser
