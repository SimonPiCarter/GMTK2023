class_name Case extends Node2D

var SIZE_ORIG = 42
@export
var SIZE = 126

var prefab_idx : int = 0
var is_tree : bool = false
var cat_placed : bool = false
var in_flame : bool = false
var timer : int = 0
var fire_duration : int = 3

var empty = false

@onready var area = $Area
@onready var shape = $Area/CollisionShape2D
@onready var label = $Label
@onready var item = $item
@onready var touched = $touched

# Called when the node enters the scene tree for the first time.
func _ready():
	stop_fire()
	shape.shape.size.x = SIZE
	shape.shape.size.y = SIZE
	touched.size.x = SIZE
	touched.size.y = SIZE
	touched.position.x = -SIZE/2.0
	touched.position.y = -SIZE/2.0
	$Sprite.scale.x = SIZE/SIZE_ORIG
	$Sprite.scale.y = SIZE/SIZE_ORIG
	item.scale.x = SIZE/SIZE_ORIG
	item.scale.y = SIZE/SIZE_ORIG

func set_empty(e : bool):
	if e:
		empty = true
		$Sprite.hide()
		label.hide()
	else:
		empty = false
		$Sprite.show()
		label.show()

func set_from_prefab(prefab : prefab_case):
	set_empty(false)
	var rng = RandomNumberGenerator.new()
	$Sprite.sprite_frames = prefab.frames[rng.randi_range(0, prefab.frames.size()-1)]
	fire_duration = prefab.fire_duration
	is_tree = prefab.is_tree
	prefab_idx = prefab.idx
	label.hide()

func decrease_timer():
	if timer == 1:
		stop_fire()
	timer = max(0, timer-1)
	label.text = String.num_int64(timer)

func stop_fire():
	if empty:
		return

	label.hide()
	in_flame = false

	$Sprite.play("default")

func start_fire():
	if empty:
		return

	in_flame = true

	if not is_tree:
		$Sprite.play("fire")
		timer = fire_duration
		if fire_duration > 0:
			label.show()
		label.text = String.num_int64(timer)


func place_cat():
	if empty or not is_tree:
		return
	$Sprite.play("cat")
	cat_placed = true
