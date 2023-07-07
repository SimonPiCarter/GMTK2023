extends Node2D

var xobj = preload("res://scene/objects/LineXObject.tscn").instantiate()
var yobj = preload("res://scene/objects/LineYObject.tscn").instantiate()

var current_obj : GridObject = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Grid.resize(5,5)
	$Grid.position = Vector2($Grid.SIZE/2,$Grid.SIZE/2)
	
	$Grid.get_elt(2, 2).set_empty(false)
	$Grid.get_elt(3, 3).set_empty(false)

	$Step.pressed.connect($Grid.decrease_timer)
	$x2.pressed.connect(objX)
	$y3.pressed.connect(objY)

	$Grid.case_clicked.connect(clicked)

	xobj.size_x = 0
	xobj.qty = 1
	yobj.size_y = 0
	yobj.qty = 1

func objX():
	if xobj.qty > 0:
		current_obj = xobj

func objY():
	if yobj.qty > 0:
		current_obj = yobj

func clicked(x, y):
	if current_obj:
		var cases = current_obj.get_case(Vector2(x,y), $Grid)
		for case in cases:
			case.start_fire()
		$Grid.decrease_timer()
		current_obj.qty -= 1

		current_obj = null

	if $Grid.check_all_case_on_fire():
		$win_screen.show()
