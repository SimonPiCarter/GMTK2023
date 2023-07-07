class_name LineYObject extends GridObject

@export var size_y : int = 1

func get_case(pos : Vector2, grid : Grid) -> Array[Case]:
	var start : int = max(0, pos.y - size_y)
	var end : int = min(grid.size_y-1, pos.y + size_y)

	var result : Array[Case] = []

	for i in range(start, end+1):
		result.push_back(grid.get_elt(pos.x, i))

	return result
