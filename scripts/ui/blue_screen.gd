extends Control

# Audio
@onready var _bluescreen_sfx : AudioStreamPlayer = $BluescreenSFX

@onready var last_score_text : Label = $MarginContainer/VBoxContainer/HBoxContainer/PreviousSessionText
@onready var highscore_text : Label = $MarginContainer/VBoxContainer/HBoxContainer2/LongestSessionText



func _ready():
	_bluescreen_sfx.play()
	last_score_text.text = Global.time_to_str(Global.game_time)
	highscore_text.text = Global.time_to_str(Global.best_time)


func _unhandled_input(event):
	if event.is_action_pressed("reboot"):
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	elif event.is_action_pressed("show_help"):
		#TODO: Implement tutorial/help screen... or not
		#print("show help")
		pass
