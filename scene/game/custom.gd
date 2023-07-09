extends Control

@onready var play = $Play
@onready var menu = $Menu
@onready var textEdit = $TextEdit
@onready var sprite_bg = $SubViewportContainer/SubViewport/AnimatedSprite2D

var sound : SoundManager = null

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_bg.play("screen2")
	play.pressed.connect(start_play)
	menu.pressed.connect(start_menu)

func start_play():
	var game = load("res://scene/game/game.tscn").instantiate()

	if textEdit.text != "":
		game.level.unserialize_level(Level.uncompress_string(textEdit.text))

	Level.switch_level(self, game)

	sound.play_fire(0)
	sound.play_music(true)

func start_menu():
	var title = load("res://scene/game/title.tscn").instantiate()

	Level.switch_level(self, title)
	title.set_up_title()
