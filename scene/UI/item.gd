class_name Item extends Control

var object : GridObject = preload("res://scene/objects/LineXObject.tscn").instantiate()

@export var qty : int = 1
@export var size_x : int = 0
@export var texture : Texture = preload("res://resources/objects/house2.tres")

@onready var tex = $tex
@onready var qty_label = $qty_label

func _ready():
	object.qty = qty
	object.size_x = size_x

	qty_label.text = String.num_int64(object.qty)

	tex.texture_normal = texture

func use():
	object.qty -= 1
	qty_label.text = String.num_int64(object.qty)
	tex.material.set_shader_parameter("width", 0.)
