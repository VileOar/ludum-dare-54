extends Node2D


## TODO: make this a dict in order to hold all file types' scenes
@export var file_scene : PackedScene
@export var corrupted_files_scene : PackedScene
@export var error_exe_scene : PackedScene
@export var download_file_scene : PackedScene
@export var recursive_file_scene : PackedScene
@export var window_scene : PackedScene
@export var download_window_scene : PackedScene
@export var recursive_window_scene : PackedScene
@export var recycling_window_scene : PackedScene

@onready var _files_holder := $Files
@onready var _windows_holder := $Windows

## this color rect simply serves to define the spawn bounds in the inspector
@onready var _bounds_rect := $Node/BoundsDelimiter

## Audio
@onready var _explode_files_sfx := $ExplodeFilesSFX
@onready var _explode_file_sfx := $ExplodeFileSFX
@onready var _popup_message_sfx := $PopupMessageSFX

#TODO: this should be temporary
var space_to_free := 0


func _ready():
	SignalManager.new_file.connect(_on_new_file)
	SignalManager.new_window.connect(_on_new_window)
	SignalManager.explode_files.connect(_on_explode_files)
	SignalManager.free_space.connect(_on_free_space)
	Global.bounds_rect = Rect2(_bounds_rect.position, _bounds_rect.size)


func _on_new_file(file_type):
	
	var file_pos = _get_position_within_bounds()
	
	_create_file(file_type, file_pos, Vector2.ZERO, 0.0)


func _on_new_window(window_type, last_position):
	var windows_pos = _get_position_within_bounds()
	var new_window
	match window_type:
		Global.WindowTypes.NORMAL:
			new_window = window_scene.instantiate()
		Global.WindowTypes.DOWNLOAD:
			new_window = download_window_scene.instantiate()
		Global.WindowTypes.RECURSIVE:
			new_window = recursive_window_scene.instantiate()
			var offset = Global.window_properties[window_type][0]["offset"]
			windows_pos = last_position + Vector2(-offset, offset)
		Global.WindowTypes.RECYCLING:
			new_window = recycling_window_scene.instantiate()
			windows_pos = last_position
			new_window.space_to_recycle = space_to_free
	
	if window_type != Global.WindowTypes.RECYCLING:
		SignalManager.corrupted_file_effect_used.emit()
	
	windows_pos = _clamp_within_bounds(windows_pos)
	var window_properties = Global.window_properties[window_type]
	var properties = window_properties[randi() % window_properties.size()]
	
	_create_window(new_window, windows_pos, properties)
	_popup_message_sfx.play()

func _on_explode_files(origin_point : Vector2, quantity : int):
	var values = Global.FileTypes.values()
	# Audio play
	if quantity == 1: 
		_explode_file_sfx.play() 
	else: 
		_explode_files_sfx.play()
	
		
	for i in range(quantity):
		var type = values[randi() % values.size()]
		
		var angle = randf() * 2 * PI
		_create_file(type, origin_point, Vector2.RIGHT.rotated(angle), Global.EXPLODE_SPEED)


func _on_free_space(space):
	space_to_free = space
	_on_new_window(Global.WindowTypes.RECYCLING, Global.RECYCLE_WINDOW_POS)


# --- || INTERNAL || ---


func _create_file(file_type : int, file_pos : Vector2, move_dir : Vector2, speed : float):
	var new_file : DraggableFile
	match file_type:
		Global.FileTypes.NORMAL:
			new_file = file_scene.instantiate()
		Global.FileTypes.INCREASE_SPAWN_EXE:
			new_file = corrupted_files_scene.instantiate()
			new_file.type = Global.FileTypes.INCREASE_SPAWN_EXE
		Global.FileTypes.CORRUPTED_FOLDER:
			new_file = corrupted_files_scene.instantiate()
			new_file.type = Global.FileTypes.CORRUPTED_FOLDER
		Global.FileTypes.ERROR_MESSAGE_EXE:
			new_file = error_exe_scene.instantiate()
			new_file.type = Global.FileTypes.ERROR_MESSAGE_EXE
		Global.FileTypes.DOWNLOAD_EXE:
			new_file = download_file_scene.instantiate()
			new_file.type = Global.FileTypes.DOWNLOAD_EXE
		Global.FileTypes.RECURSIVE:
			new_file = recursive_file_scene.instantiate()
			new_file.type = Global.FileTypes.RECURSIVE
	
	if new_file == null:
		push_error("file type not found")
		return
	
	var files_properties = Global.file_properties[file_type]
	var properties = files_properties[randi() % files_properties.size()]

	new_file.position = file_pos
	new_file.move_dir = move_dir
	new_file.speed = speed
	new_file.file_size = properties["size"]
	
	_files_holder.add_child(new_file)
	
	new_file.text = properties["name"]
	new_file.set_icon(properties["anim_name"])
	

func _create_window(window_instance : DraggableWindow, window_pos : Vector2, properties : Dictionary):
	_windows_holder.add_child(window_instance)
	window_instance.position = window_pos
	window_instance.title = properties["title"]
	window_instance.description = properties["description"]


## return a position within desktop bounds
func _get_position_within_bounds():
	var xx = randf_range(-_bounds_rect.size.x/2, _bounds_rect.size.x/2)
	var yy = randf_range(-_bounds_rect.size.y/2, _bounds_rect.size.y/2)
	var pos = Vector2(xx, yy)
	
	return pos


func _clamp_within_bounds(pos : Vector2) -> Vector2:
	var xx = clamp(pos.x, Global.bounds_rect.position.x, Global.bounds_rect.end.x)
	var yy = clamp(pos.y, Global.bounds_rect.position.y, Global.bounds_rect.end.y)
	return Vector2(xx, yy)
