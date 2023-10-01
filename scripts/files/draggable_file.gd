extends Node2D

class_name DraggableFile
@onready var label : Label = $Label
@onready var rect = get_viewport_rect()
@onready var xx = rect.size.x/2 - 20
@onready var yy = rect.size.y/2 - 20

@onready var _selected_panel := $PanelContainer
@onready var _anim := $FileIcon

## whether the file can be put in recycle bin
var can_recycle = true
## whether the file can be put in antivirus
var can_antivirus = false

var lifted := false
var selected := false
var disabled := false:
	set(val):
		if not val:
			process_mode = Node.PROCESS_MODE_INHERIT
		else:
			process_mode = Node.PROCESS_MODE_DISABLED

var mouse_offset := Vector2.ZERO
var text : String = "":
	set(value):
		if label == null: return
		label.text = value


## default file size
@export var file_size := 5

@export var move_dir := Vector2.ONE
@export var speed := 0.0

@export var drag := 16.0

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
	else:
		position += speed * move_dir * delta
		speed = move_toward(speed, 0.0, drag)
		
		if position.x < Global.bounds_rect.position.x or position.x > Global.bounds_rect.end.x:
			position.x = clamp(position.x, Global.bounds_rect.position.x, Global.bounds_rect.end.x)
			move_dir.x = -move_dir.x
		if position.y < Global.bounds_rect.position.y or position.y > Global.bounds_rect.end.y:
			position.y = clamp(position.y, Global.bounds_rect.position.y, Global.bounds_rect.end.y)
			move_dir.y = -move_dir.y


func _on_color_rect_gui_input(event):
	if Global.ignore_inputs: return
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					# if another file is clicked besides the already selected ones, deselect them
					if not Global.selected_files.has(self):
						for file in Global.selected_files:
							file.set_lifted(false)
							file.set_selected(false, false)
						Global.selected_files = []
						set_selected(true)
					# otherwise, add self to selected and grab all selected
					for file in Global.selected_files:
						file.set_lifted(true)
				else:
					for file in Global.selected_files:
						file.set_lifted(false)
					SignalManager.release_files.emit(Global.selected_files)
			# RIGHT CLICK HANDLER GOES HERE


func set_icon(anim_name : String):
	_anim.play(anim_name)

func set_lifted(val : bool):
	lifted = val
	if not val: return
	mouse_offset = position - get_global_mouse_position()
	# Put file on "top" of parent children
	var parent = get_parent()
	get_parent().move_child(self, -1)

func set_disabled(val : bool):
	disabled = val

func delete():
	queue_free()

func set_selected(val : bool, alter_list := true):
	selected = val
	if val:
		if not Global.selected_files.has(self) and alter_list:
			Global.selected_files.append(self)
		_selected_panel.show()
	else:
		if alter_list:
			Global.selected_files.erase(self)
		_selected_panel.hide()


func get_file_icon_anim() -> String:
	return _anim.animation
