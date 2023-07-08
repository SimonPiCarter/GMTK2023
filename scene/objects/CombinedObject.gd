class_name CombinedObject extends GridObject

var sub_objects : Array[GridObject] = []

func get_case(pos : Vector2, grid : Grid) -> Array[Case]:
	var res : Array[Case] = []

	for obj in sub_objects:
		res.append_array(obj.get_case(pos, grid))

	return res

func clone() -> GridObject:
	var cloned = CombinedObject.new()
	cloned.sub_objects = sub_objects.duplicate(true)
	return cloned
