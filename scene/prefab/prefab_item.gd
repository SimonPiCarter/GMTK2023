class_name prefab_item extends Node

var idx : int = 0
var qty : int = 1
var object : GridObject = LineXObject.new()
var texture : Texture = preload("res://resources/objects/fire_0.tres")
var texture_disabled : Texture = preload("res://resources/objects/fire_0.tres")

# set up object here
func _init():
	pass
