extends Node2D

@onready var panel : Panel = $Panel
var final_mouse_pos := Vector2.ZERO
var initial_mouse_pos := Vector2.ZERO
var dragging := false

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	final_mouse_pos = mouse_pos
	var offset = final_mouse_pos - initial_mouse_pos
	
	# Fix negative sized panel
	if offset.x < 0:
		position.x = offset.x + initial_mouse_pos.x
	if offset.y < 0:
		position.y = offset.y + initial_mouse_pos.y
	
	panel.size = abs(offset)
	

func _unhandled_input(event):
	# Draggable Area
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					var mouse_pos = get_global_mouse_position()
					initial_mouse_pos = mouse_pos
					position = mouse_pos
					panel.show()
					dragging = true
				else:
					panel.hide()
					dragging = false
