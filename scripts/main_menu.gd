extends Control

## Background
@onready var bg_transition = $Background/BGTransition # TODO: change background image
@onready var animation = $AnimationPlayer

func _ready():
	animation.play("fade_in")


func _on_start_gui_input(event):
	if is_left_click(event):
		print("start")

func _on_how_to_play_gui_input(event):
	if is_left_click(event):
		print("how to play")

func _on_exit_gui_input(event):
	if is_left_click(event):
		animation.play("exit")
	
func is_left_click(event) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"exit":
			get_tree().quit()



