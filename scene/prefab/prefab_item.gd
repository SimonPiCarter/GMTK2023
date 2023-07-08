class_name prefab_item extends Node

var qty : int = 1
var object : GridObject = preload("res://scene/objects/LineXObject.tscn").instantiate()
var texture : Texture = preload("res://resources/objects/house1.tres")

# set up object here
func _init():
	pass
