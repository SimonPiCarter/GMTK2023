class_name Item extends Control

var object : GridObject = preload("res://scene/objects/LineXObject.tscn").instantiate()

@onready var tex = $tex
@onready var qty_label = $qty_label

func _ready():
	object.qty = 1
	object.size_x = 0
	qty_label.text = String.num_int64(object.qty)
	

func use():
	object.qty -= 1
	qty_label.text = String.num_int64(object.qty)
	tex.material.set_shader_parameter("width", 0.)
