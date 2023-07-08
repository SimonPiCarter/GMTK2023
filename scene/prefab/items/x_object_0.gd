class_name x_object_0 extends prefab_item

# set up object here
func _init():
	object = preload("res://scene/objects/LineXObject.tscn").instantiate()
	object.size_x = 0
	texture = preload("res://resources/objects/house1.tres")
