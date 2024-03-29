extends Node2D

@onready var menu = $VBoxContainer/HBoxContainer/Menu
@onready var reloader = $VBoxContainer/HBoxContainer/Reload
@onready var restarter = $VBoxContainer/HBoxContainer/Reset
@onready var laoder = $VBoxContainer/HBoxContainer/Load
@onready var box = $VBoxContainer/ScrollContainer/box
@onready var box_case = $VBoxContainer/ScrollContainer2/box
@onready var eraser_toogle = $VBoxContainer/HBoxContainer/Eraser
@onready var serialize_label = $VBoxContainer/TextEdit
@onready var player = $VBoxContainer/HBoxContainer/Play
@onready var mute = $mute

var sound : SoundManager = null

var items : Array[Item] = []
var items_case : Array[ItemCase] = []

var current_item : ItemCase = null
var eraser = false

var grid_margin = 5

var level : Level = Level.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signals
	$Step.pressed.connect($Grid.decrease_timer)
	menu.pressed.connect(back_to_menu)
	restarter.pressed.connect(restart)
	reloader.pressed.connect(reload)
	laoder.pressed.connect(loadSeed)
	player.pressed.connect(play)
	mute.pressed.connect(mute_sound)

	level.unserialize_level("00000000000010000000000020120")

	$Grid.case_clicked.connect(clicked)
	$Grid.case_entered.connect(entered)
	$Grid.case_exited.connect(exited)

	eraser_toogle.toggled.connect(switch_eraser)

	reload()

func back_to_menu():
	var title = load("res://scene/game/title.tscn").instantiate()

	Level.switch_level(self, title)
	title.set_up_title()

	if sound:
		sound.play_intro(true)

func mute_sound():
	if not sound:
		return
	if mute.button_pressed:
		sound.mute()
	else:
		sound.unmute()

func restart():
	level = Level.new()
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
	$Grid.position = Vector2(600-5*$Grid.SIZE/2+$Grid.SIZE/2,$Grid.SIZE/2 + grid_margin)

	$TextureRect.position.x = 600-5*$Grid.SIZE/2
	$TextureRect.size.x = 5*$Grid.SIZE
	$TextureRect.size.y = 5*$Grid.SIZE

	# meta data
	var loader = JsonLoader.new()
	loader.read("res://resources/meta/prefabs.json")

	# level
	for x in range(0, $Grid.size_x):
		for y in range(0, $Grid.size_y):
			var prefab = level.getCase(x,y)
			if prefab > 0:
				$Grid.get_elt(x, y).set_from_prefab(loader.prefabs_case_loaded[prefab-1])

	# clear items
	for child in box.get_children():
		child.queue_free()

	var prefab_idx = 0
	# loading items
	for prefab in loader.prefabs_loaded:
		var child = preload("res://scene/UI/item.tscn").instantiate()
		box.add_child(child)
		child.set_prefab(prefab)
		if prefab_idx < level.items.size():
			child.set_qty(level.items[prefab_idx])
		items.push_back(child)
		child.tex.pressed.connect(select.bind(child))
		prefab_idx += 1

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

	serialize_label.text = Level.compress_string(serialize_level())

func loadSeed():
	level = Level.new()
	level.unserialize_level(Level.uncompress_string(serialize_label.text))
	reload()

func play():
	var game = load("res://scene/game/game.tscn").instantiate()

	game.set_levels([serialize_label.text])
	game.scripts.clear()

	game.get_node("volume/mute").button_pressed = mute.button_pressed
	Level.switch_level(self, game)

func switch_eraser(state : bool):
	eraser = state
	if state:
		select_case(current_item)

func select_case(item : ItemCase):
	reset_all_items()
	if current_item == item and current_item:
		current_item.lowlight()
		current_item = null
	elif item:
		item.highlight()
		current_item = item
		eraser_toogle.button_pressed = false
		eraser = false

	if sound:
		sound.play_clic()

func select(item : Item):
	if item.object.qty < 9:
		item.set_qty(item.object.qty + 1)
	else:
		item.set_qty(0)
	do_serialize()

	if sound:
		sound.play_clic()

func clicked(x, y):
	if current_item:
		$Grid.get_elt(x, y).set_from_prefab(current_item.prefab)
	elif eraser:
		$Grid.get_elt(x, y).set_empty(true)

	do_serialize()

	if sound:
		sound.play_clic()

## Event handling
func entered(x, y):
	if current_item:
		$Grid.get_elt(x,y).item.texture = current_item.prefab.frames[0].get_frame_texture("default",0)
		$Grid.get_elt(x,y).item.show()

	else:
		$Grid.get_elt(x,y).item.hide()

func exited(x, y):
	$Grid.get_elt(x,y).item.hide()

func reset_all_items():
	for item in items_case:
		item.lowlight()

func serialize_level() -> String:
	var lvl = Level.new()
	lvl.loadFromGridAndItems($Grid, items)
	return lvl.serialize_level()

func do_serialize():
	serialize_label.text = Level.compress_string(serialize_level())
