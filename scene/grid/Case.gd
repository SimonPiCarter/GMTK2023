class_name Case extends Node2D

var in_flame : bool = false
var timer : int = 0
var fire_duration : int = 5

var empty = false

@onready var area = $Area
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	stop_fire()

func set_empty(e : bool):
	if e:
		empty = true
		$Sprite.hide()
		label.hide()
	else:
		empty = false
		$Sprite.show()
		label.show()

func decrease_timer():
	if timer == 1:
		stop_fire()
	timer = max(0, timer-1)
	label.text = String.num_int64(timer)

func stop_fire():
	if empty:
		return

	in_flame = false

	$Sprite.material.set_shader_parameter("color", Vector4(1,1,1,1))

func start_fire():
	if empty:
		return

	in_flame = true
	timer = fire_duration

	$Sprite.material.set_shader_parameter("color", Vector4(1,0,0,1))

	label.text = String.num_int64(timer)
