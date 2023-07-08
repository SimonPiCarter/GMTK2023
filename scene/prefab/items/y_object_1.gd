class_name y_object_1 extends prefab_item

# set up object here
func _init():
	object = preload("res://scene/objects/LineYObject.tscn").instantiate()
	object.size_y = 1
	texture = preload("res://resources/objects/house4.tres")
