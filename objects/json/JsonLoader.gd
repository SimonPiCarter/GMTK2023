class_name JsonLoader extends Node

var prefabs_loaded : Array[prefab_item] = []
var prefabs_case_loaded : Array[prefab_case] = []

func read(path : String):
	var file = FileAccess.open(path, FileAccess.READ)
	var content : String = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		# clear all data
		prefabs_loaded.clear()
		prefabs_case_loaded.clear()

		var data = json.data

		# fill prefabs

		# items
		var idx : int = 0
		var prefabs = data["item_prefabs"]
		for prefab in prefabs:
			var loaded = prefab_item.new()
			loaded.idx = idx
			idx += 1

			if prefab["objects"].size() == 1:
				loaded.object = readObject(prefab["objects"][0])
			else:
				loaded.object = CombinedObject.new()
				for sub_object in prefab["objects"]:
					loaded.object.sub_objects.push_back(readObject(sub_object))

			loaded.texture = load(prefab["texture"])
			loaded.texture_disabled = load(prefab["texture_disabled"])
			loaded.qty = prefab["qty"]

			prefabs_loaded.push_back(loaded)

		# cases
		idx = 0
		prefabs = data["case_prefabs"]
		for prefab in prefabs:
			var loaded = prefab_case.new()
			loaded.idx = idx
			idx += 1

			loaded.frames.clear()
			for frame in prefab["frames"]:
				loaded.frames.push_back(load(frame))
			loaded.is_protected = prefab["is_protected"]
			loaded.is_forbidden = prefab["is_forbidden"]
			loaded.fire_duration = prefab["fire_duration"]
			loaded.is_tree = prefab["is_tree"]
			prefabs_case_loaded.push_back(loaded)

	else:
		push_error("failed to load ",path)

func readObject(data) -> GridObject:
	var size : int = data["size"]
	var object : GridObject = null
	if data["type"] == "AXline":
		object = ALineXObject.new()
		if size >= 0:
			object.size_x = size
		else:
			object.size_x = -size
			object.reversed = true

	elif data["type"] == "AYline":
		object = ALineYObject.new()
		if size >= 0:
			object.size_y = size
		else:
			object.size_y = -size
			object.reversed = true
	elif data["type"] == "Xline":
		object = LineXObject.new()
		if size >= 0:
			object.size_x = size
	elif data["type"] == "Yline":
		object = LineYObject.new()
		if size >= 0:
			object.size_y = size
	elif data["type"] == "Cat":
		object = CatObject.new()
	else:
		push_error("Could not read object from ", data)
	return object
