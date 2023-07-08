class_name cross_object_1 extends prefab_item

# set up object here
func _init():
	object = CombinedObject.new()
	var x_obj = LineXObject.new()
	x_obj.size_x = 1
	var y_obj = LineYObject.new()
	y_obj.size_y = 1
	object.sub_objects.push_back(x_obj)
	object.sub_objects.push_back(y_obj)
	texture = preload("res://resources/objects/house1.tres")
