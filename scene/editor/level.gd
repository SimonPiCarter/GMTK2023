class_name Level extends Node

var grid_size : int = 5
var cases : Array[int] = []
var items : Array[int] = []

func _init():
	init()

func init():
	cases.clear()
	items.clear()
	for i in range(0,grid_size*grid_size):
		cases.push_back(0)
	for i in range(0,10):
		items.push_back(0)

func setCase(val : int, x : int, y : int):
	cases[x*grid_size+y] = val

func getCase(x : int, y : int) -> int:
	return cases[x*grid_size+y]

func loadFromGridAndItems(grid : Grid, items_array : Array[Item]):
	cases.clear()
	items.clear()
	for elt in grid.data:
		if elt.empty:
			cases.push_back(0)
		else:
			cases.push_back(elt.prefab_idx+1)

	for item in items_array:
		items.push_back(item.object.qty)



# ################ #
# SERIALIZATION
# ################ #

func serialize_level() -> String:
	var ser : String  = ""
	for case in cases:
		if case > 9:
			push_error("could not serialize level! Because too many distinct case type")
		ser += String.num_int64(case)
	for item in items:
		if item > 9:
			push_error("could not serialize level! Because too many distinct case type")
		ser += String.num_int64(item)

	return ser

func unserialize_level(string : String):
	cases.clear()
	items.clear()
	var array = string.rsplit()

	if array.size() < grid_size*grid_size:
		push_error("could not unserliaze string ", string)
		init()
		return

	for idx in range(0, grid_size*grid_size):
		cases.push_back(int(array[idx]))

	for idx in range(grid_size*grid_size, array.size()):
		items.push_back(int(array[idx]))

# ################ #
# COMPRESSION
# ################ #

static func compress_string(string : String) -> String:
	var compressed : String = string
	compressed = compressed.replace("000000000", "i")
	compressed = compressed.replace("00000000", "u")
	compressed = compressed.replace("0000000", "y")
	compressed = compressed.replace("000000", "t")
	compressed = compressed.replace("00000", "a")
	compressed = compressed.replace("0000", "z")
	compressed = compressed.replace("000", "e")
	compressed = compressed.replace("00", "r")
	return compressed

static func uncompress_string(string : String) -> String:
	var uncompressed : String = string
	uncompressed = uncompressed.replace("i", "000000000")
	uncompressed = uncompressed.replace("u", "00000000")
	uncompressed = uncompressed.replace("y", "0000000")
	uncompressed = uncompressed.replace("t", "000000")
	uncompressed = uncompressed.replace("a", "00000")
	uncompressed = uncompressed.replace("z", "0000")
	uncompressed = uncompressed.replace("e", "000")
	uncompressed = uncompressed.replace("r", "00")
	return uncompressed
