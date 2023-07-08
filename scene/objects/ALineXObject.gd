class_name ALineXObject extends GridObject

@export var size_x : int = 1
@export var reversed : bool = false

func get_case(pos : Vector2, grid : Grid) -> Array[Case]:
	var start : int = max(0, pos.x)
	var end : int = min(grid.size_x-1, pos.x + size_x)
	if reversed:
		start = max(0, pos.x-size_x)
		end = min(grid.size_x-1, pos.x)

	var result : Array[Case] = []

	for i in range(start, end+1):
		result.push_back(grid.get_elt(i, pos.y))

	return result

func clone() -> GridObject:
	var cloned = ALineXObject.new()
	cloned.size_x = size_x
	cloned.reversed = reversed
	return cloned

