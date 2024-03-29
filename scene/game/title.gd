extends Control

@onready var play = $Play
@onready var editor = $Editor
@onready var custom = $Custom
@onready var credits = $Credits
@onready var sprite_bg = $SubViewportContainer/SubViewport/AnimatedSprite2D
@onready var sprite_truck = $SubViewportContainer/SubViewport/truck
@onready var black = $black
@onready var timer = $Timer
@onready var timer_fade = $Timer_fade
@onready var diag_r = $diag_r
@onready var diag_l = $diag_l
@onready var player = $player
@onready var credit_box = $credit_box

# sound can be overrided before insertion into tree
# to avoid sound breaking
var sound : SoundManager = null

var state : int = 0
var credits_on : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not sound:
		sound = $sound
	else:
		# override sound
		remove_child($sound)
		# sound should already be added
		#add_child(sound)

	player.play("fade_out")
	player.animation_finished.connect(cond_start)

	sound.play_fire(1)
	play.pressed.connect(startPlay)
	editor.pressed.connect(startEditor)
	custom.pressed.connect(startCustom)
	credits.pressed.connect(startCredits)
	sprite_bg.play("default")
	timer_fade.timeout.connect(switch_scene)

func switch_scene():
	sprite_bg.play("screen2")

func cond_start(anim):
	if anim == "fade_out":
		start_dialog()
	if anim == "truck_move_title":
		player.play("title_scale")

func start_dialog():
	diag_r.set_text("911, what's your emergency?")
	diag_r.read()

	diag_r.auto_over = true
	diag_r.is_over.connect(transition)
	diag_r.show()
	diag_l.auto_over = true
	diag_l.is_over.connect(transition)
	diag_l.hide()

func transition():
	if state == 0:
		diag_r.hide()
		diag_l.show()
		diag_l.set_text("Skrrrr... Please! Come fast! My House... Skrrrr... Burning!")
		diag_l.read()
	if state == 1:
		diag_l.hide()
		diag_r.show()
		diag_r.set_text("Oh no! quick! That's a mission for us! Let's help this poor soul!")
		diag_r.read()
	if state == 2:
		sound.play_truck()
		diag_r.hide()
		timer.start(2)
		timer.timeout.connect(transition)
		player.play("truck_move")
	if state == 3:
		timer_fade.start(0.75)
		player.play("fade")
	if state == 4:
		set_up_title()
		sound.play_music(true)

	state += 1

# directly set to title screen (skip intro)
func set_up_title():
	diag_r.stop()
	diag_l.stop()
	sprite_truck.position.x = 250
	player.play("truck_move_title")
	switch_scene()
	play.show()
	editor.show()
	custom.show()
	timer.stop()
	state = 4
	$skip.hide()

func startPlay():
	var game = preload("res://scene/game/game.tscn").instantiate()

	var script_tuto_1 = dialog_script.new()
	script_tuto_1.texts.push_back("See this house? How it is not burning ? We need to act fast and burn it before anyone gets hurt!")
	script_tuto_1.types.push_back(dialog_script.Type.Firefighter)
	game.scripts.push_back(script_tuto_1)

	var script_tuto_2 = dialog_script.new()
	script_tuto_2.texts.push_back("Thanks to our very well designed firefighter gears we can light multiple houses at once. Check it out. Be wary supply may be limited.")
	script_tuto_2.types.push_back(dialog_script.Type.Firefighter)
	game.scripts.push_back(script_tuto_2)

	var script_tuto_3 = dialog_script.new()
	script_tuto_3.texts.push_back("Oh no! This house is particularly resistant to fire! It will burn for shorter time, and that's a problem !")
	script_tuto_3.texts.push_back("When you set a house on fire always check the conveniently placed timer to know when it will stop burning.")
	script_tuto_3.types.push_back(dialog_script.Type.Firefighter)
	script_tuto_3.types.push_back(dialog_script.Type.Firefighter)
	game.scripts.push_back(script_tuto_3)

	var script_tuto_4 = dialog_script.new()
	script_tuto_4.texts.push_back("See this tree hover there? We need to be careful to not set it up on fire. How the hell are we going to put back the cats on it otherwise?")
	script_tuto_4.types.push_back(dialog_script.Type.Firefighter)
	script_tuto_4.texts.push_back("Please! my poor cat fell of the tree, help him climb back on it!")
	script_tuto_4.types.push_back(dialog_script.Type.Grandma)
	script_tuto_4.texts.push_back("Of course ! We just need to deal with all the fire before! Just to ensure your cat is safe.")
	script_tuto_4.types.push_back(dialog_script.Type.Firefighter)
	game.scripts.push_back(script_tuto_4)

	var script_tuto_5 = dialog_script.new()
	script_tuto_5.texts.push_back("Mmmmh... That's a lot of cats.")
	script_tuto_5.types.push_back(dialog_script.Type.Firefighter)
	script_tuto_5.texts.push_back("...")
	script_tuto_5.types.push_back(dialog_script.Type.Grandma)
	game.scripts.push_back(script_tuto_5)

	game.set_levels([ \
		"ir1iz1u", \
		"ir101iz1t", \
		"y2r302z2y4u", \
		"y1r3141e1y3e1r10", \
		"34e44144r1434414434e1z2201", \
		"0404r1410141404101404t1212r",\
		"y1e111r414043034z12010", \
		"z44044r4014r41041444e12z", \
		"30101243e114e3214r21434203540", \
		"2420101320141404022312401632212130", \
		"02e431102243e2y1e21010", \
		"31414r120201031403432012934433351", \
		"1421241441213323214114212989555550", \
		"142r42404301324344414120934022030", \
		"r21012032014031410142024984234440", \
		"4140210134010240420210404944333251 ", \
		"0413402414412323442010341545055040", \
		"4444444444444444444444444i", \
	])

	Level.switch_level(self, game)

	sound.play_fire(0)
	sound.play_music(true)

func startEditor():
	var scene = preload("res://scene/editor/editor_main.tscn").instantiate()

	Level.switch_level(self, scene)

	sound.play_fire(0)
	sound.play_music(true)

func startCustom():
	var scene = preload("res://scene/game/custom.tscn").instantiate()

	Level.switch_level(self, scene)

func startCredits():
	if credits_on:
		black.color = Color(0,0,0,0)
		play.disabled = false
		editor.disabled = false
		custom.disabled = false
		credit_box.hide()
	else:
		black.color = Color(0,0,0,0.75)
		play.disabled = true
		editor.disabled = true
		custom.disabled = true
		credit_box.show()
	credits_on = not credits_on

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_SPACE and state < 4:
		sound.play_music(true)
		set_up_title()
