extends Node2D

class_name DraggableWindow


@onready var close_button : Button = $PanelContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CloseButton
@onready var window_text : Label = $PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/Description
@onready var window_title : Label = $PanelContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Title

var lifted := false
var lift_pos_offset = Vector2.ZERO 

var title : String = "":
	set(value):
		if window_text == null: return
		window_text.text = value
var description : String = "":
	set(value):
		if window_title == null: return
		window_title.text = value


func _physics_process(_delta):
	if lifted:
		position = get_global_mouse_position() - lift_pos_offset


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
	self.queue_free()
