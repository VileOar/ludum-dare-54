extends Node

@onready var _defeat_sfx = $DefeatSFX
@onready var _music_audio : AudioStreamPlayer = $MusicPlayer
@onready var _panic_music_audio : AudioStreamPlayer = $PanicMusicPlayer

@onready var _timer : Timer = $Timer
@onready var _is_disk_at_warning_level := false
@onready var _audio_fades_animation := $AnimationPlayer

@export var transition_duration : float = 6.00
@export var time_till_music_starts : float = 3.00


func _ready():
	SignalManager.disk_almost_full.connect(_on_disk_almost_full)
	SignalManager.play_game_over_sfx.connect(_game_over)
	fade_in(_music_audio, 1.00)
	_panic_music_audio.play()
	_panic_music_audio.volume_db = UtilsAudio.MIN_VOLUME
	_timer.wait_time = time_till_music_starts

# TODO delete. it's not used anymore
func _on_timer_timeout():
	fade_out(_music_audio, transition_duration)

# Signal comes frmo disk toolbar
func _game_over():
	_defeat_sfx.play()
	_panic_music_audio.stop()
	_music_audio.stop()


func _on_disk_almost_full(is_disk_almost_full):
	# if disk is playing panic song and no longer is almost full. fades out
	if _is_disk_at_warning_level:
		if !is_disk_almost_full:
			_audio_fades_animation.play("change_to_normal")
#			print("warning = true | back to normal music")
#			fade_out(_panic_music_audio, transition_duration)
#			fade_in(_music_audio, time_till_music_starts)
			_is_disk_at_warning_level = false
	
	if !_is_disk_at_warning_level:
		if is_disk_almost_full:
			_audio_fades_animation.play("change_to_panic")
#			print("warning = false | panic music")
#			fade_in(_panic_music_audio, time_till_music_starts)
#			fade_out(_music_audio, transition_duration)
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
	

