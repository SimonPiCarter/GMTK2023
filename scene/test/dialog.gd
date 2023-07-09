extends Node2D

@onready var dialog = $dialog
@onready var voice = $voice
@onready var text = $dialog/Label

var reading : bool = false
var muted : bool = false
var over : bool = false

# character per second
var reading_speed : int = 20
var read_step : float = 0

signal is_over()

func read():
	var rand = RandomNumberGenerator.new()
	reading = true
	read_step = 0
	over = false
	if not muted:
		voice.play(rand.randf_range(0, 10.))
	speed_up(false)

func mute():
	muted = true
	voice.stop()

func speed_up(speed : bool = true):
	if speed:
		reading_speed = 200
		voice.pitch_scale = 2
	else:
		reading_speed = 20
		voice.pitch_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not reading:
		return

	read_step += delta * reading_speed

	text.visible_characters = read_step

	if text.visible_characters >= text.text.length():
		voice.stop()
		over = true

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if over:
			is_over.emit()
		elif reading:
			speed_up()
