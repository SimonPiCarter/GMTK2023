class_name CatObject extends GridObject

func clone() -> GridObject:
	var cloned = CatObject.new()
	return cloned

func is_cat() -> bool:
	return true
