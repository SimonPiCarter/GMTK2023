class_name ALineYObject extends GridObject

@export var size_y : int = 1
@export var reversed : bool = false

func get_case(pos : Vector2, grid : Grid) -> Array[Case]:
	var start : int = max(0, pos.y)
	var end : int = min(grid.size_y-1, pos.y + size_y)
	if reversed:
		start = max(0, pos.y - size_y)
		end = min(grid.size_y-1, pos.y)

	var result : Array[Case] = []

	for i in range(start, end+1):
		result.push_back(grid.get_elt(pos.x, i))

	return result

func clone() -> GridObject:
	var cloned = LineYObject.new()
	cloned.size_y = size_y
	cloned.reversed = reversed
	return cloned
