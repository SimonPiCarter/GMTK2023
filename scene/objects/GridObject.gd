class_name GridObject extends Node

var qty : int = 1

func get_case(_pos : Vector2, _grid : Grid) -> Array[Case]:
	return []

func clone() -> GridObject:
	push_error("could not clone GridObject")
	return GridObject.new()
