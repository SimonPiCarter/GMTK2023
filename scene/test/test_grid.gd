extends Node2D

@onready var restart = $VBoxContainer/HBoxContainer/Restart
@onready var next = $VBoxContainer/HBoxContainer/Next
@onready var box = $VBoxContainer/ScrollContainer/box

var items : Array[Item] = []

var current_item : Item = null

var grid_margin = 20

var current_case : Vector2i = Vector2i(-1,-1)

# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signals
	$Step.pressed.connect($Grid.decrease_timer)
	restart.pressed.connect(reload)

	$Grid.case_clicked.connect(clicked)
	$Grid.case_entered.connect(entered)
	$Grid.case_exited.connect(exited)

	reload()

func reload():
	# clear
	items.clear()
	$win_screen.hide()
	$lose_screen.hide()
	current_item = null

	# loading level
	$Grid.resize(5,5)
	$Grid.position = Vector2($Grid.SIZE/2 + grid_margin,$Grid.SIZE/2 + grid_margin)

	# meta data
	var loader = JsonLoader.new()
	loader.read("res://resources/meta/prefabs.json")

	# level

	$Grid.get_elt(0, 1).set_from_prefab(loader.prefabs_case_loaded[0])
	$Grid.get_elt(2, 1).set_from_prefab(loader.prefabs_case_loaded[0])
	$Grid.get_elt(4, 1).set_from_prefab(loader.prefabs_case_loaded[0])
	$Grid.get_elt(2, 2).set_from_prefab(loader.prefabs_case_loaded[1])
	$Grid.get_elt(0, 2).set_from_prefab(loader.prefabs_case_loaded[1])

	# loading items
	for child in box.get_children():
		child.queue_free()

	for prefab in loader.prefabs_loaded:
		var child = preload("res://scene/UI/item.tscn").instantiate()
		box.add_child(child)
		child.set_prefab(prefab)
		items.push_back(child)
		child.tex.pressed.connect(select.bind(child))


func select(item : Item):
	reset_all_items()
	if item.object.qty > 0:
		current_item = item
		current_item.highlight()

func clicked(x, y):
	if current_item:
		var current_obj = current_item.object
		var cases = current_obj.get_case(Vector2(x,y), $Grid)
		for case in cases:
			case.start_fire()

		current_item.use()
		current_item = null

		if $Grid.check_all_case_on_fire():
			$win_screen.show()
		elif no_more_items():
			$lose_screen.show()
		else:
			$Grid.decrease_timer()

	reset_all_items()
	$Grid.reset_all_markers()
	$Grid.get_elt(x,y).item.hide()

## lose condition
func no_more_items() -> bool:
	for item in items:
		if item.object.qty > 0:
			return false
	return true

## Event handling
func entered(x, y):
	if current_item:
		$Grid.reset_all_markers()
		current_case = Vector2i(x,y)

		var cases = current_item.object.get_case(Vector2(x,y), $Grid)
		for case in cases:
			case.touched.show()

		$Grid.get_elt(x,y).item.texture = current_item.prefab.texture
		$Grid.get_elt(x,y).item.show()

	else:
		$Grid.get_elt(x,y).item.hide()

func exited(x, y):
	$Grid.get_elt(x,y).item.hide()
	if current_case.x == x and current_case.y == y:
		$Grid.reset_all_markers()

func reset_all_items():
	for item in items:
		item.lowlight()
