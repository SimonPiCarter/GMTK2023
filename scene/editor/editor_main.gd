extends Node2D

@onready var restart = $VBoxContainer/HBoxContainer/Restart
@onready var next = $VBoxContainer/HBoxContainer/Next
@onready var box = $VBoxContainer/ScrollContainer/box
@onready var box_case = $VBoxContainer/ScrollContainer2/box
@onready var eraser_toogle = $VBoxContainer/HBoxContainer/Eraser

var items : Array[Item] = []
var items_case : Array[ItemCase] = []

var current_item : ItemCase = null
var eraser = false

var grid_margin = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signals
	$Step.pressed.connect($Grid.decrease_timer)
	restart.pressed.connect(reload)

	$Grid.case_clicked.connect(clicked)
	$Grid.case_entered.connect(entered)
	$Grid.case_exited.connect(exited)

	eraser_toogle.toggled.connect(switch_eraser)

	reload()

func reload():
	# clear
	items.clear()
	items_case.clear()
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

	# clear items
	for child in box.get_children():
		child.queue_free()

	# loading items
	for prefab in loader.prefabs_loaded:
		var child = preload("res://scene/UI/item.tscn").instantiate()
		box.add_child(child)
		child.set_prefab(prefab)
		child.set_qty(0)
		items.push_back(child)
		child.tex.pressed.connect(select.bind(child))

	# clear items
	for child in box_case.get_children():
		child.queue_free()

	# loading cases
	for prefab in loader.prefabs_case_loaded:
		var child = preload("res://scene/UI/item_case.tscn").instantiate()
		box_case.add_child(child)
		child.set_prefab(prefab)
		items_case.push_back(child)
		child.tex.pressed.connect(select_case.bind(child))

func switch_eraser(state : bool):
	eraser = state

func select_case(item : ItemCase):
	reset_all_items()
	item.tex.material.set_shader_parameter("width", 1.)
	current_item = item
	eraser_toogle.button_pressed = false
	eraser = false

func select(item : Item):
	if item.object.qty < 9:
		item.set_qty(item.object.qty + 1)
	else:
		item.set_qty(0)

func clicked(x, y):
	if current_item:
		$Grid.get_elt(x, y).set_from_prefab(current_item.prefab)

		current_item.tex.material.set_shader_parameter("width", 0.)
		current_item = null
	elif eraser:
		$Grid.get_elt(x, y).set_empty(true)

## lose condition
func no_more_items() -> bool:
	for item in items:
		if item.object.qty > 0:
			return false
	return true

## Event handling
func entered(x, y):
	if current_item:
		$Grid.get_elt(x,y).item.texture = current_item.prefab.frames.get_frame_texture("default",0)
		$Grid.get_elt(x,y).item.show()

	else:
		$Grid.get_elt(x,y).item.hide()

func exited(x, y):
	$Grid.get_elt(x,y).item.hide()

func reset_all_items():
	for item in items_case:
		item.tex.material.set_shader_parameter("width", 0.)
