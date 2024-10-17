extends Control
## NOTE: This script and associated scene have been rewritten

@onready var _menu_audio = $MenuAudio

## Background
@onready var bg_transition = $Background/BGTransition # TODO: change background image
@onready var animation = $AnimationPlayer
@onready var user_options = $MainUsers/UserContainer/UserOptions

@export var main_scene : PackedScene

var credits := false
var start := false


func _ready():
	animation.play("enter")


func _on_start_pressed():
	_menu_audio.play_click_sfx()
	animation.play("turn")
	start = true


func _on_how_to_play_pressed():
	_menu_audio.play_click_sfx()
	animation.play("hide_menu")


func _on_credits_pressed():
	_menu_audio.play_click_sfx()
	animation.play("hide_menu")
	credits = true


func _on_exit_pressed():
	get_tree().quit()

func _on_back_pressed():
	_menu_audio.play_click_sfx()
	animation.play("hide_credits")
	credits = false


func _on_back_2_pressed():
	_menu_audio.play_click_sfx()
	animation.play("hide_howto")


func _on_animation_player_animation_finished(anim_name):
	#print("Animation ended = " + anim_name)
	match anim_name:
		"turn":
			get_tree().change_scene_to_packed(main_scene)
		"hide_menu":
			if credits:
				animation.play("show_credits")
			else:
				animation.play("show_howto")


func _on_mouse_entered(idx):
	var label : Label = user_options.get_child(idx).get_child(1)
	label.modulate = Color(0.75, 0.75, 0.75, 1)

func _on_mouse_exited(idx):
	var label : Label = user_options.get_child(idx).get_child(1)
	label.modulate = Color(1, 1, 1, 1)

# Being called by signals
func _on_mouse_entered_sfx():
	_menu_audio.play_hover_sfx()
