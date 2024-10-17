extends Node2D

class_name DraggableWindow

# Audio
@onready var _click_sfx = $ClickSFX
@onready var _hover_sfx = $HoverSFX

@onready var close_button : Button = %CloseButton
@onready var window_text : Label = %Description
@onready var window_title : Label = %Title

var lifted := false
var lift_pos_offset = Vector2.ZERO 

## how many of these there are
static var exist_counter = 0

var title : String = "":
	set(value):
		window_title.text = value
var description : String = "":
	set(value):
		window_text.text = value


func _enter_tree():
	exist_counter += 1


func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			exist_counter = max(exist_counter - 1, 0)


func _physics_process(_delta):
	if lifted:
		position = get_global_mouse_position() - lift_pos_offset


func play_hover_sfx():
	_hover_sfx.play()


func play_click_sfx():
	_click_sfx.play()


func _on_panel_container_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					lifted = true

					# calculate offset
					lift_pos_offset = get_global_mouse_position() - position

					# Put file on "top" of parent children
					get_parent().move_child(self, -1)
				else:
					lifted = false


func _on_close_button_pressed():
	play_click_sfx()
	await _click_sfx.finished
	self.queue_free()
