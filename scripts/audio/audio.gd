extends Node

var _computer_on_audio : AudioStreamPlayer
var _music_audio : AudioStreamPlayer

@export var transition_duration : float = 6.00
@export var time_till_music_starts : float = 6.00


func _ready():
	# Prepare audio streams
#	await get_tree().create_timer(4.0).timeout
	_computer_on_audio = get_node("ComputerOn")
	_music_audio = get_node("MusicPlayer")
	
	# Execution
	_computer_on_audio.play()
	fade_in(_music_audio)
	

func _on_timer_timeout():
	fade_out(_computer_on_audio)


# Source: https://ask.godotengine.org/27939/how-to-fade-in-out-an-audio-stream
func fade_out(stream_player):
	print("Fade out called")
	# tween music volume down to 0
	var _tween_off = get_tree().create_tween()
	_tween_off.tween_property(stream_player, "volume_db", -80, transition_duration)
	# when the tween ends, the music will be stopped
	
func fade_in(stream_player):
	print("Fade in called")
	var _tween_in = get_tree().create_tween()
	stream_player.volume_db = -80
	stream_player.play()
	_tween_in.tween_property(stream_player, "volume_db", -20, transition_duration)
	# when the tween ends, the music will be stopped
	
# stop the music -- otherwise it continues to run at silent volume
func _on_TweenOut_tween_completed(object, _key):
	print("fade out completed")
	object.stop()
