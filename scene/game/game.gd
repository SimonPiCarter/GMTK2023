extends Node2D

@onready var box = $VBoxContainer/ScrollContainer/box

@onready var win_timer = $win_timer

@onready var menu = $VBoxContainer/HBoxContainer/Menu
@onready var restart = $VBoxContainer/HBoxContainer/Restart
@onready var editor = $VBoxContainer/HBoxContainer/Editor
@onready var mute = $volume/mute
@onready var sound_level = $volume/level
@onready var prev = $VBoxContainer/HBoxContainer/Prev
@onready var next = $VBoxContainer/HBoxContainer/Next

@onready var dialog = $dialog

@onready var lvl_label = $VBoxContainer2/Lvl
@onready var burning_label = $VBoxContainer2/Flames

var items : Array[Item] = []

var current_item : Item = null

var grid_margin = 5

var current_case : Vector2i = Vector2i(-1,-1)

var level : Level = Level.new()

var sound : SoundManager = null

var over : bool = false
var all_on_fire : bool = false
var started : bool = false

var current_level : int = 0
var levels : Array[String] = []
var scripts : Array[dialog_script] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# connecting signals
	$Step.pressed.connect($Grid.decrease_timer)
	menu.pressed.connect(back_to_menu)
	restart.pressed.connect(reload)
	$restart_lose.pressed.connect(reload)
	editor.pressed.connect(editor_load)
	mute.pressed.connect(mute_sound)
	prev.pressed.connect(prev_level)
	next.pressed.connect(next_level)
	$next_win.pressed.connect(next_level)
	dialog.is_over.connect(start)

	$Grid.case_clicked.connect(clicked)
	$Grid.case_entered.connect(entered)
	$Grid.case_exited.connect(exited)

	win_timer.timeout.connect(win)

	sound_level.value_changed.connect(change_sound_level)

	load_level(0)

func change_sound_level(lvl : float):
	var volume_db = -6. + (1. - lvl/100.)*(-12)
	AudioServer.set_bus_volume_db(0, volume_db)
	if lvl < 1:
		mute.button_pressed = true
		mute_sound()
	elif mute.button_pressed:
		mute.button_pressed = false
		mute_sound()

func set_levels(lvls : Array):
	levels.clear()
	levels.append_array(lvls)

func next_level():
	load_level(current_level+1)

func prev_level():
	load_level(current_level-1)

func load_level(lvl : int):
	if lvl < levels.size() and lvl >= 0:
		current_level = lvl
		level.unserialize_level(Level.uncompress_string(levels[lvl]))
		lvl_label.text = "Level : "+String.num_int64(lvl+1)+"/"+String.num_int64(levels.size())
		reload()
	elif lvl >= levels.size():
		back_to_menu()

func win():
	$win_screen.show()
	$next_win.show()
	$background.show()
	menu.disabled = false
	restart.disabled = false
	editor.disabled = false
	prev.disabled = false
	next.disabled = false
	over = true
	if sound:
		sound.play_win()
	win_timer.stop()

func back_to_menu():
	var title = load("res://scene/game/title.tscn").instantiate()

	Level.switch_level(self, title)
	title.set_up_title()
	sound.play_intro(true)

func start():
	started = true
	dialog.hide()

func reload():
	dialog.hide()
	if current_level < scripts.size() and scripts[current_level].texts.size() > 0:
		started = false
		dialog.show()
		dialog.set_scripts(scripts[current_level])
		dialog.read()
		if sound and sound.muted:
			dialog.mute()
		else:
			dialog.unmute()
	else:
		started = true
	over = false
	all_on_fire = false
	if sound:
		sound.play_fire(0)
	# clear
	items.clear()
	$win_screen.hide()
	$next_win.hide()
	$lose_screen.hide()
	$restart_lose.hide()
	$background.hide()
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
			if prefab > 0 and prefab-1 < loader.prefabs_case_loaded.size():
				$Grid.get_elt(x, y).set_from_prefab(loader.prefabs_case_loaded[prefab-1])

	# loading items
	for child in box.get_children():
		child.queue_free()

	var prefab = 0
	for qty in level.items:
		if prefab >= loader.prefabs_loaded.size():
			break
		var is_cat : bool = loader.prefabs_loaded[prefab].object.is_cat()
		var need_cat : bool = $Grid.has_trees()
		if (not is_cat and qty > 0) or (is_cat and need_cat):
			var child = preload("res://scene/UI/item.tscn").instantiate()
			box.add_child(child)
			child.set_prefab(loader.prefabs_loaded[prefab])
			child.set_qty(qty)
			items.push_back(child)
			child.tex.pressed.connect(select.bind(child))
			if is_cat and not $Grid.check_all_case_on_fire():
				child.disable()
		prefab += 1

	burning_label.text = "Burning : "+String.num_int64($Grid.get_nb_case_on_fire())+"/"+String.num_int64($Grid.get_nb_case_to_set_on_fire())

func editor_load():
	var scene = load("res://scene/editor/editor_main.tscn").instantiate()

	if sound:
		sound.play_fire(0)

	scene.get_node("mute").button_pressed = mute.button_pressed

	Level.switch_level(self, scene)

	scene.level.unserialize_level(level.serialize_level())
	scene.reload()

func mute_sound():
	if not sound:
		return
	if mute.button_pressed:
		sound.mute()
		dialog.mute()
		sound_level.value = 0
	else:
		sound.unmute()
		dialog.unmute()
		sound_level.value = 100

func select(item : Item):
	if over or not started:
		return
	reset_all_items()
	if item.object.qty > 0 and not item.object.is_cat() and not all_on_fire:
		current_item = item
		current_item.highlight()

	if item.object.is_cat() and $Grid.check_all_case_on_fire():
		sound.play_cat()
		$Grid.place_cats()
		win_timer.start(1)
		menu.disabled = true
		restart.disabled = true
		editor.disabled = true
		prev.disabled = true
		next.disabled = true

	if sound:
		sound.play_clic()

func clicked(x, y):
	if over or not started:
		return
	if current_item:
		var current_obj = current_item.object
		var cases = current_obj.get_case(Vector2(x,y), $Grid)
		for case in cases:
			case.start_fire()

		current_item.use()
		if current_item.object.qty == 0:
			current_item = null
			$Grid.reset_all_markers()
			$Grid.get_elt(x,y).item.hide()

		if sound:
			var nb_on_fire : int = $Grid.get_nb_case_on_fire()

			# min 1 if one case on fire
			sound.play_fire(max(min(1, nb_on_fire), int(nb_on_fire / 3.)))

		if $Grid.check_all_case_on_fire():
			for item in items:
				if item.object.is_cat():
					item.enable()
				else:
					item.hide()
			all_on_fire = true

		burning_label.text = "burning : "+String.num_int64($Grid.get_nb_case_on_fire())+"/"+String.num_int64($Grid.get_nb_case_to_set_on_fire())

		if $Grid.check_all_case_on_fire() and $Grid.check_cats_on_tree():
			win()
		elif (no_more_items() and not $Grid.check_all_case_on_fire()) or $Grid.tree_on_fire():
			over = true
			$lose_screen.show()
			$restart_lose.show()
			$background.show()
			if sound:
				sound.play_lose()
		elif not all_on_fire:
			$Grid.decrease_timer()

	reset_all_items()

	if sound:
		sound.play_clic()

## lose condition
func no_more_items() -> bool:
	for item in items:
		if item.object.qty > 0 and not item.object.is_cat():
			return false
	return true

## Event handling
func entered(x, y):
	if over:
		return
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
