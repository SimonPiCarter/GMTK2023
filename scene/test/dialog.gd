extends Node2D

@onready var dialog = $dialog
@onready var voice = $voice
@onready var text = $dialog/Label

var reading : bool = false
var muted : bool = false

# character per second
var reading_speed : int = 20
var read_step : float = 0

func read():
	var rand = RandomNumberGenerator.new()
	reading = true
	if not muted:
		voice.play(rand.randf_range(0, 10.))

func mute():
	muted = true
	voice.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not reading:
		return

	read_step += delta

	text.visible_characters = read_step * reading_speed
	
	if text.visible_characters >= text.text.length():
		voice.stop()
