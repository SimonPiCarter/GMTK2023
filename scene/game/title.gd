extends Control

@onready var play = $Button
@onready var sound = $sound

# Called when the node enters the scene tree for the first time.
func _ready():
	play.pressed.connect(startPlay)

func startPlay():
	var game = load("res://scene/game/game.tscn").instantiate()
	game.level.unserialize_level(Level.uncompress_string("a333333333333333333330129"))

	# transmit sound
	remove_child(sound)
	game.add_child(sound)
	game.sound = sound

	get_parent().add_child(game)
	queue_free()
