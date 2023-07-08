class_name x_object_1 extends prefab_item

# set up object here
func _init():
	object = preload("res://scene/objects/LineXObject.tscn").instantiate()
	object.size_x = 1
	texture = preload("res://resources/objects/house2.tres")
