extends Node2D

class_name DraggableFile

var lifted := false
var mouse_offset := Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lifted:
		position = get_global_mouse_position() + mouse_offset


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					# Multiple Selection
					if Global.selected_files.is_empty():
						set_lifted(true)
					else:
						for file in Global.selected_files:
							file.set_lifted(true)
				else:
					set_lifted(false)
					# Multiple Selection
					if Global.selected_files.is_empty():
						SignalManager.release_file.emit(self)
					else:
						SignalManager.release_files.emit(Global.selected_files)
			# RIGHT CLICK HANDLER GOES HERE

func set_lifted(val : bool):
	lifted = val
	if not val: return
	mouse_offset = position - get_global_mouse_position()
	# Put file on "top" of parent children
	var parent = get_parent()
	get_parent().move_child(self, -1)
