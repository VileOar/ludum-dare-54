extends Control
class_name Antivirus

@onready var _quarantine_grid = %QuarantineGrid
@onready var _grid_detector = %Area2D
@onready var _purge_progressbar = %PurgeProgressbar

var _mouse_hovered := false

var _active := false:
	set(val):
		_active = val
		if val:
			show()
		else:
			hide()

## a position way out of screen, where files are sent when they are in quarantine, so I don't have
## to bother with deleting and recreating them if they pop out of quarantine
var _shadow_realm := Vector2(50000, 50000)

## to determine the next file to be replaced
var _quarantine_queue := []
var _max_quarantine_size := 4



var _purge_counter := 0.0
var _purge_speed := 100.0 # %/sec
var _purging := false


func _ready():
	SignalManager.toggle_antivirus.connect(_on_toggle_antivirus)
	SignalManager.release_files.connect(_on_release_files)
	_max_quarantine_size = _quarantine_grid.get_child_count()
	_active = true
	


func _process(delta):
	if _purging:
		_purge_counter += _purge_speed * delta
		_purge_progressbar.value = _purge_counter
		if _purge_counter >= 100.0:
			_purge_files()


func _drop_in_quarantine(file : DraggableFile):
	if not file.can_antivirus:
		file.play_error_anim()
		return
	
	# it pops all stored files until there is a free slot
	while _quarantine_queue.size() > _max_quarantine_size - 1:
		var pop_file := _quarantine_queue.pop_back() as DraggableFile
		_swap_out_file(pop_file)
	
	file.set_disabled(true)
	file.global_position = _shadow_realm
	file.set_lifted(false)
	file.set_selected(false)
	_quarantine_queue.push_front(file)
	
	_update_grid_graphics()


func _swap_out_file(file : DraggableFile):
	file.set_disabled(false)
	file.global_position = _grid_detector.global_position + Vector2(0, -128)
	file.speed = Global.EXPLODE_SPEED
	var angle = randf_range(-PI/4, PI/4)
	file.move_dir = Vector2.UP.rotated(angle)


func _purge_files():
	while _quarantine_queue.size() > 0:
		var file = _quarantine_queue.pop_back() as DraggableFile
		if file is EvilFile:
			file.disable_effects()
		_swap_out_file(file)
	
	_purging = false
	_purge_counter = 0.0
	_purge_progressbar.value = _purge_counter
	_update_grid_graphics()


func _update_grid_graphics():
	# update grid graphics
	var first_empty = 0
	for ix in range(_quarantine_queue.size()):
		_quarantine_grid.get_child(ix).set_icon(_quarantine_queue[ix].get_file_icon_anim())
		first_empty += 1
	
	# set remaining as empty
	while first_empty < _quarantine_grid.get_child_count():
		_quarantine_grid.get_child(first_empty).set_icon("")
		first_empty += 1


func _on_release_files(files : Array):
	if _mouse_hovered and _active:
		for i in range(files.size() - 1, -1, -1):
			var file = files[i]
			_drop_in_quarantine(file)


func _on_toggle_antivirus():
	_active = not _active


func _on_area_2d_mouse_entered():
	_mouse_hovered = true


func _on_area_2d_mouse_exited():
	_mouse_hovered = false


func _on_purge_button_pressed():
	if not _quarantine_queue.is_empty():
		_purging = true
