extends Node2D

class_name DraggableWindow


var lifted := false
var liftPosOffset = Vector2.ZERO 


func _physics_process(_delta):
	if lifted:
		position = get_global_mouse_position() - liftPosOffset


func _on_panel_container_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					lifted = true

					# calculate offset
					liftPosOffset = get_global_mouse_position() - position

					# Put file on "top" of parent children
					get_parent().move_child(self, -1)
				else:
					lifted = false
			# RIGHT CLICK HANDLER GOES HERE


func _on_close_button_pressed():
	self.queue_free()


func _on_button_pressed():
	self.queue_free()
	
