extends Node

@onready var _music_audio : AudioStreamPlayer = $MusicPlayer
@onready var _panic_music_audio : AudioStreamPlayer = $PanicMusicPlayer
@onready var _timer : Timer = $Timer

@export var transition_duration : float = 6.00
@export var time_till_music_starts : float = 3.00


func _ready():
	SignalManager.disk_almost_full.connect(_on_disk_almost_full)
	fade_in(_music_audio, 1.00)
	_timer.wait_time = time_till_music_starts
	

func _on_timer_timeout():
	print("start playing music")
	fade_out(_music_audio, transition_duration)


func _on_disk_almost_full():
	print("on disk almost full")
	fade_in(_panic_music_audio, time_till_music_starts)
	_timer.start()


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
