class_name Item extends Control

@export var prefab : prefab_item = prefab_item.new()

var object : GridObject = null

@onready var tex = $tex
@onready var qty_label = $qty_label

func _ready():
	reset()

func set_prefab(new_prefab : prefab_item):
	prefab = new_prefab
	reset()

func reset():
	object = prefab.object.clone()
	object.qty = prefab.qty

	qty_label.text = String.num_int64(object.qty)

	tex.texture_normal = prefab.texture

func use():
	object.qty -= 1
	qty_label.text = String.num_int64(object.qty)
	tex.material.set_shader_parameter("width", 0.)
