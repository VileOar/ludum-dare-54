extends Node2D

class_name DraggableFile

var lifted := false
var mouse_offset := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lifted:
		position = get_global_mouse_position() + mouse_offset


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					lifted = true
					mouse_offset = position - get_global_mouse_position()
					# Put file on "top" of parent children
					var parent = get_parent()
					get_parent().move_child(self, -1)
				else:
					lifted = false
					SignalManager.release_file.emit(self)
			# RIGHT CLICK HANDLER GOES HERE
