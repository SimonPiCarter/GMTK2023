class_name LineXObject extends GridObject

@export var size_x : int = 1

func get_case(pos : Vector2, grid : Grid) -> Array[Case]:
	var start : int = max(0, pos.x - size_x)
	var end : int = min(grid.size_x-1, pos.x + size_x)

	var result : Array[Case] = []

	for i in range(start, end+1):
		result.push_back(grid.get_elt(i, pos.y))

	return result
