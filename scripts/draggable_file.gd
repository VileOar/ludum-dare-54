extends Node2D

class_name DraggableFile

var lifted := false
var selected := false
var mouse_offset := Vector2.ZERO
@onready var rect = get_viewport_rect()
@onready var xx = rect.size.x/2 - 20
@onready var yy = rect.size.y/2 - 20

@onready var _selected_panel := $PanelContainer

## default file size
@export var file_size := 5

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.file_created.emit(self)


func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			Global.selected_files.erase(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if lifted:
		position = get_global_mouse_position() + mouse_offset
		position.x = clamp(position.x, -xx, xx)
		position.y = clamp(position.y, -yy, yy)


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					# if another file is clicked besides the already selected ones, deselect them
					if not Global.selected_files.has(self):
						for file in Global.selected_files:
							file.set_lifted(false)
							file.set_selected(false)
						set_selected(true)
					# otherwise, add self to selected and grab all selected
					for file in Global.selected_files:
						file.set_lifted(true)
				else:
					for file in Global.selected_files:
						file.set_lifted(false)
					SignalManager.release_files.emit(Global.selected_files)
			# RIGHT CLICK HANDLER GOES HERE

func set_lifted(val : bool):
	lifted = val
	if not val: return
	mouse_offset = position - get_global_mouse_position()
	# Put file on "top" of parent children
	var parent = get_parent()
	get_parent().move_child(self, -1)


func set_selected(val : bool):
	selected = val
	if val:
		if not Global.selected_files.has(self):
			Global.selected_files.append(self)
		_selected_panel.show()
	else:
		Global.selected_files.erase(self)
		_selected_panel.hide()
