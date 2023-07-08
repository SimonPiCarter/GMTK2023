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
	tex.texture_normal = prefab.frames[0].get_frame_texture("default",0)

func highlight():
	tex.material.set_shader_parameter("width", 1.)

func lowlight():
	tex.material.set_shader_parameter("width", 0.)
