class_name SoundManager extends Node

@onready var music_player = $music_player
@onready var clic_player = $clic_player
@onready var win_player = $win_player
@onready var lose_player = $lose_player
@onready var fire_player_1 = $fire_player_1
@onready var fire_player_2 = $fire_player_3
@onready var fire_player_3 = $fire_player_2

var muted : bool = false
var fire_level : int = 0

func mute():
	muted = true
	music_player.stop()
	clic_player.stop()
	win_player.stop()
	fire_player_1.stop()
	fire_player_2.stop()
	fire_player_3.stop()

func unmute():
	muted = false
	music_player.play()
	play_fire(fire_level)

func _ready():
	if muted:
		return
	play_music(true)

func play_music(play : bool):
	if muted:
		return
	if play:
		music_player.play()
	else:
		music_player.stop()

func play_clic():
	if muted:
		return
	clic_player.play()

func play_win():
	if muted:
		return
	win_player.play()

func play_lose():
	if muted:
		return
	lose_player.play()

func play_fire(lvl : int):
	fire_level = lvl
	if muted:
		return
	if lvl <= 0:
		fire_player_1.stop()
		fire_player_2.stop()
		fire_player_3.stop()
	elif lvl == 1:
		fire_player_1.play()
		fire_player_2.stop()
		fire_player_3.stop()
	elif lvl == 2:
		fire_player_1.stop()
		fire_player_2.play()
		fire_player_3.stop()
	else:
		fire_player_1.stop()
		fire_player_2.stop()
		fire_player_3.play()
