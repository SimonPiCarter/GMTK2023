extends Node2D

@onready var item1 = $box/item1
@onready var item2 = $box/item2

var current_item : Item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Grid.resize(5,5)
	$Grid.position = Vector2($Grid.SIZE/2,$Grid.SIZE/2)
	
	$Grid.get_elt(2, 2).set_empty(false)
	$Grid.get_elt(3, 3).set_empty(false)

	$Step.pressed.connect($Grid.decrease_timer)
	item1.tex.pressed.connect(objX)
	item2.tex.pressed.connect(objY)

	$Grid.case_clicked.connect(clicked)

func objX():
	reset_all_items()
	if item1.object.qty > 0:
		current_item = item1
		current_item.tex.material.set_shader_parameter("width", 1.)

func objY():
	reset_all_items()
	if item2.object.qty > 0:
		current_item = item2
		current_item.tex.material.set_shader_parameter("width", 1.)

func clicked(x, y):
	if current_item:
		var current_obj = current_item.object
		var cases = current_obj.get_case(Vector2(x,y), $Grid)
		for case in cases:
			case.start_fire()

		current_item.use()
		current_obj = null

		$Grid.decrease_timer()

		if $Grid.check_all_case_on_fire():
			$win_screen.show()

	reset_all_items()

func reset_all_items():
	item1.tex.material.set_shader_parameter("width", 0.)
	item2.tex.material.set_shader_parameter("width", 0.)
