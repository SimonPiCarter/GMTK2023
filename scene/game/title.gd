extends Control

@onready var play = $Play
@onready var editor = $Editor
@onready var custom = $Custom
@onready var sprite_bg = $SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var sprite_truck = $SubViewportContainer/SubViewport/truck
@onready var timer = $Timer
@onready var timer_fade = $Timer_fade
@onready var player = $player

# sound can be overrided before insertion into tree
# to avoid sound breaking
var sound : SoundManager = null

var state : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if not sound:
		sound = $sound
	else:
		# override sound
		remove_child($sound)
		# sound should already be added
		#add_child(sound)

	sound.play_fire(1)
	play.pressed.connect(startPlay)
	editor.pressed.connect(startEditor)
	custom.pressed.connect(startCustom)
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
		editor.show()
		custom.show()
		timer.stop()

	state += 1

# directly set to title screen (skip intro)
func set_up_title():
	sprite_truck.position.x = 250
	player.play("truck_move_title")
	switch_scene()
	play.show()
	editor.show()
	custom.show()
	timer.stop()
	state = 4

func startPlay():
	var game = load("res://scene/game/game.tscn").instantiate()
	game.level.unserialize_level(Level.uncompress_string("01z2z24e204r1z3e1111"))

	Level.switch_level(self, game)

	sound.play_fire(0)
	sound.play_music(true)

func startEditor():
	var scene = load("res://scene/editor/editor_main.tscn").instantiate()

	Level.switch_level(self, scene)

	sound.play_fire(0)
	sound.play_music(true)

func startCustom():
	var scene = load("res://scene/game/custom.tscn").instantiate()

	Level.switch_level(self, scene)
