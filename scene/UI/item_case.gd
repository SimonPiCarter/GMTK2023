class_name ItemCase extends Control

@export var prefab : prefab_case = prefab_case.new()

var object : GridObject = null

@onready var tex = $tex

func _ready():
	reset()

func set_prefab(new_prefab : prefab_case):
	prefab = new_prefab
	reset()

func reset():
	tex.texture_normal = prefab.frames.get_frame_texture("default",0)
