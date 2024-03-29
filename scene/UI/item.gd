class_name Item extends Control

@export var prefab : prefab_item = prefab_item.new()

var object : GridObject = null

var disabled : bool = false

@onready var tex = $tex
@onready var qty_label = $qty_label
@onready var light = $light

func _ready():
	reset()

func set_prefab(new_prefab : prefab_item):
	prefab = new_prefab
	reset()

func reset():
	object = prefab.object.clone()
	object.qty = prefab.qty

	qty_label.text = String.num_int64(object.qty)

	if object.is_cat():
		qty_label.hide()

	tex.texture_normal = prefab.texture

func highlight():
	light.show()

func lowlight():
	light.hide()

func use():
	object.qty -= 1
	qty_label.text = String.num_int64(object.qty)
	tex.material.set_shader_parameter("width", 0.)

func set_qty(new_qty : int):
	object.qty = new_qty
	qty_label.text = String.num_int64(object.qty)

func disable():
	disabled = true
	tex.texture_normal = prefab.texture_disabled

func enable():
	disabled = false
	tex.texture_normal = prefab.texture
