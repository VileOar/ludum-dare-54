extends Control

## Background
@onready var bg_transition = $Background/BGTransition # TODO: change background image
@onready var animation = $AnimationPlayer
@onready var user_options = $MainUsers/UserContainer/UserOptions
@onready var back = $Credits/BackContainer/Back
@onready var back2 = $HowToPlay/BackContainer2/Back2

@export var main_scene : PackedScene

var credits := false
var start := false

func _ready():
	animation.play("enter")

# TODO: add options settings

func _on_start_gui_input(event):
	if is_left_click(event):
		animation.play("turn")
		start = true

func _on_how_to_play_gui_input(event):
	if is_left_click(event):
		animation.play("hide_menu")
		
func _on_credits_gui_input(event):
	if is_left_click(event):
		animation.play("hide_menu")
		credits = true
	
func _on_exit_gui_input(event):
	if is_left_click(event):
		animation.play("turn")

func _on_back_container_gui_input(event):
	if is_left_click(event):
		animation.play("hide_credits")
		credits = false

func _on_back_container_2_gui_input(event):
	if is_left_click(event):
		animation.play("hide_howto")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"turn":
			if start:
				get_tree().change_scene_to_packed(main_scene)
			else:
				get_tree().quit()
		"hide_menu":
			if credits:
				animation.play("show_credits")
			else:
				animation.play("show_howto")

func is_left_click(event) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed

func _on_mouse_entered(idx):
	var label : Label = user_options.get_child(idx).get_child(1)
	label.modulate = Color(0.75, 0.75, 0.75, 1)

func _on_mouse_exited(idx):
	var label : Label = user_options.get_child(idx).get_child(1)
	label.modulate = Color(1, 1, 1, 1)


func _on_back_container_mouse_entered():
	back.modulate = Color(0.75, 0.75, 0.75, 1)

func _on_back_container_mouse_exited():
	back.modulate = Color(1, 1, 1, 1)

func _on_back_container_2_mouse_entered():
	back2.modulate = Color(0.75, 0.75, 0.75, 1)

func _on_back_container_2_mouse_exited():
	back2.modulate = Color(1, 1, 1, 1)
