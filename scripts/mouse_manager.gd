extends Node2D

@onready var panel : Panel = $Panel
@onready var selection_area : Area2D = $SelectionArea
@onready var selection_shape = $SelectionArea/SelectionShape

signal select_files(files)

var final_mouse_pos := Vector2.ZERO
var initial_mouse_pos := Vector2.ZERO
var dragging := false
var selected_files : Array = []

func _physics_process(delta):
	create_drag_area()

func create_drag_area():
	if not dragging: return
	var mouse_pos = get_global_mouse_position()
	final_mouse_pos = mouse_pos
	var offset = final_mouse_pos - initial_mouse_pos
	
	# Fix negative sized panel
	if offset.x < 0:
		panel.position.x = offset.x + initial_mouse_pos.x
	if offset.y < 0:
		panel.position.y = offset.y + initial_mouse_pos.y
	panel.size = abs(offset)
	
	# Area2D offset
	var shape = selection_shape.shape
	shape.size = panel.size
	selection_area.position = (panel.position + abs(offset) / 2)

func _unhandled_input(event):
	# Draggable Area
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					var mouse_pos = get_global_mouse_position()
					initial_mouse_pos = mouse_pos
					panel.position = mouse_pos
					panel.show()
					dragging = true
				else:
					panel.hide()
					dragging = false


func _on_selection_area_area_entered(area):
	if dragging:
		Global.selected_files.append(area.owner)
#	SignalManager.select_files.emit(selected_files)


func _on_selection_area_area_exited(area):
	if dragging:
		Global.selected_files.erase(area.owner)
#	SignalManager.select_files.emit(selected_files)
	


