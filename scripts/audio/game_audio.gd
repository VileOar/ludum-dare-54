extends Node

@onready var _music_audio : AudioStreamPlayer = $MusicPlayer
@onready var _panic_music_audio : AudioStreamPlayer = $PanicMusicPlayer
@onready var _timer : Timer = $Timer
@onready var _is_disk_at_warning_level := false

@export var transition_duration : float = 6.00
@export var time_till_music_starts : float = 3.00


func _ready():
	SignalManager.disk_almost_full.connect(_on_disk_almost_full)
	fade_in(_music_audio, 1.00)
	_timer.wait_time = time_till_music_starts

# TODO delete. it's not used anymore
func _on_timer_timeout():
	fade_out(_music_audio, transition_duration)
	print("warning is now = false \n timeout")


func _on_disk_almost_full(is_disk_almost_full):
	# if disk is playing panic song and no longer is almost full. fades out
	if _is_disk_at_warning_level:
		if !is_disk_almost_full:
#			print("warning = true | back to normal music")
			fade_out(_panic_music_audio, transition_duration)
			fade_in(_music_audio, time_till_music_starts)
			_is_disk_at_warning_level = false
	
	if !_is_disk_at_warning_level:
		if is_disk_almost_full:
#			print("warning = false | panic music")
			fade_in(_panic_music_audio, time_till_music_starts)
			fade_out(_music_audio, transition_duration)
			_is_disk_at_warning_level = true


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
