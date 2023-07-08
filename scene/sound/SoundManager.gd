class_name SoundManager extends Node

@onready var music_player = $music_player
@onready var clic_player = $clic_player
@onready var win_player = $win_player
@onready var fire_player_1 = $fire_player_1
@onready var fire_player_2 = $fire_player_3
@onready var fire_player_3 = $fire_player_2

func _ready():
	play_music(true)

func play_music(play : bool):
	if play:
		music_player.play()
	else:
		music_player.stop()

func play_clic():
	clic_player.play()

func play_win():
	win_player.play()

func play_lose():
	pass

func play_fire(lvl : int):
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
