extends Control
class_name Antivirus

@onready var _quarantine_grid = %QuarantineGrid
@onready var _grid_detector = %Area2D

var _mouse_hovered := false

var _active := false

## a position way out of screen, where files are sent when they are in quarantine, so I don't have
## to bother with deleting and recreating them if they pop out of quarantine
var _shadow_realm := Vector2(50000, 50000)

## to determine the next file to be replaced
var _quarantine_queue := []
var _max_quarantine_size := 4


func _ready():
	SignalManager.toggle_antivirus.connect(_on_toggle_antivirus)
	SignalManager.release_files.connect(_on_release_files)
	_max_quarantine_size = _quarantine_grid.get_child_count()


func _drop_in_quarantine(file : DraggableFile):
	if not file.can_antivirus: return
	
	# it pops all stored files until there is a free slot
	while _quarantine_queue.size() > _max_quarantine_size - 1:
		var pop_file := _quarantine_queue.pop_back() as DraggableFile
		pop_file.set_disabled(false)
		pop_file.global_position = _grid_detector.global_position + Vector2(0, -128)
		pop_file.speed = Global.EXPLODE_SPEED
		var angle = randf_range(-PI/4, PI/4)
		pop_file.move_dir = Vector2.UP.rotated(angle)
	
	file.set_disabled(true)
	file.global_position = _shadow_realm
	file.set_lifted(false)
	file.set_selected(false)
	_quarantine_queue.push_front(file)
	
	# update grid graphics
	for ix in range(_quarantine_queue.size()):
		_quarantine_grid.get_child(ix).set_icon(_quarantine_queue[ix].get_file_icon_anim())


func _on_release_files(files : Array):
	if _mouse_hovered and _active:
		for i in range(files.size() - 1, -1, -1):
			var file = files[i]
			_drop_in_quarantine(file)


func _on_toggle_antivirus():
	_active = not _active
	if _active:
		show()
	else:
		hide()


func _on_area_2d_mouse_entered():
	_mouse_hovered = true


func _on_area_2d_mouse_exited():
	_mouse_hovered = false
