extends Node2D

@onready var dialog = $dialog
@onready var voice = $voice
@onready var text = $dialog/Label

var reading : bool = false
var muted : bool = false
var over : bool = false
var over_emitted : bool = false

# character per second
var reading_speed : int = 20
var read_step : float = 0

# set to true and no clic will be required for dialog to emit is_over signal
var auto_over = false
# time after end when the signal is going to be emitted if auto_over is true
var auto_over_timer = 0.5

signal is_over()

func _ready():
	$Timer.timeout.connect(send_over)

func send_over():
	if not over_emitted:
		is_over.emit()
		over_emitted = true

func set_text(inText : String):
	text.text = inText

func read():
	var rand = RandomNumberGenerator.new()
	reading = true
	read_step = 0
	over = false
	over_emitted = false
	if not muted:
		voice.play(rand.randf_range(0, 10.))
	speed_up(false)

func stop():
	hide()
	over_emitted = true
	voice.stop()

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

	if text.visible_characters >= text.text.length() and not over:
		voice.stop()
		over = true
		if auto_over:
			$Timer.start(auto_over_timer)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if over:
			send_over()
		elif reading:
			speed_up()
