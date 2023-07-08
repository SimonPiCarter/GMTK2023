extends Control

@onready var play = $Play
@onready var editor = $Editor
@onready var custom = $Custom
@onready var sound = $sound
@onready var sprite_bg = $SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var sprite_truck = $SubViewportContainer/SubViewport/truck
@onready var timer = $Timer
@onready var timer_fade = $Timer_fade
@onready var player = $player

var state : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	sound.play_fire(1)
	play.pressed.connect(startPlay)
	sprite_bg.play("default")
	timer.start(2)
	timer.timeout.connect(transition)
	timer_fade.timeout.connect(switch_scene)

func switch_scene():
	sprite_bg.play("screen2")

func transition():
	if state == 0:
		player.play("truck_move")
	if state == 1:
		timer_fade.start(0.75)
		player.play("fade")
	if state == 2:
		sprite_truck.position.x = 250
		player.play("truck_move_2")
	if state == 3:
		sound.play_intro(true)
		player.play("title")
		play.show()
		timer.stop()

	state += 1

func startPlay():
	var game = load("res://scene/game/game.tscn").instantiate()
	game.level.unserialize_level(Level.uncompress_string("01z2z24e204r1z3e1111"))

	# transmit sound
	remove_child(sound)
	game.add_child(sound)
	game.sound = sound

	get_parent().add_child(game)
	queue_free()
	sound.play_music(true)
