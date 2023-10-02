extends Node

@onready var _computer_on_audio : AudioStreamPlayer = $ComputerOn
@onready var _music_audio : AudioStreamPlayer = $MainMenuMusic
@onready var _click_sfx : AudioStreamPlayer = $ClickSFX
@onready var _hover_sfx : AudioStreamPlayer = $HoverSFX
@onready var _timer : Timer = $Timer

@export var transition_duration : float = 6.00
@export var time_till_music_starts : float = 3.00


# On turning the game on, plays sound
func _ready():
	_computer_on_audio.play()
	
	
# Called from main menu animation player to start the music when menu appears	
func start_menu_music():
	fade_in(_music_audio, time_till_music_starts)
	_timer.wait_time = time_till_music_starts
	_timer.start()
	
	
func play_click_sfx():
	_click_sfx.play()
	
	
func play_hover_sfx():
	_hover_sfx.play()
	
# Fades out the computer on
func _on_timer_timeout():
	fade_out(_computer_on_audio, transition_duration)


# Source: https://ask.godotengine.org/27939/how-to-fade-in-out-an-audio-stream
func fade_out(stream_player, duration):
	# tween music volume down to 0
	var _tween_off = get_tree().create_tween()
	_tween_off.tween_property(stream_player, "volume_db", UtilsAudio.MIN_VOLUME, duration)
	# when the tween ends, the music will be stopped
	
func fade_in(stream_player, duration):
	var _tween_in = get_tree().create_tween()
	stream_player.volume_db = UtilsAudio.MIN_VOLUME
	stream_player.play()
	_tween_in.tween_property(stream_player, "volume_db", UtilsAudio.DEFAULT_VOLUME, duration)
	# when the tween ends, the music will be stopped
	
# stop the music -- otherwise it continues to run at silent volume
func _on_TweenOut_tween_completed(object, _key):
	print("fade out completed")
	object.stop()
