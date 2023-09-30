extends Node2D


## TODO: make this a dict in order to hold all file types' scenes
@export var file_scene : PackedScene
@export var corrupted_files_scene : PackedScene

@onready var _files_holder := $Files
@onready var _windows_holder := $Windows

## this color rect simply serves to define the spawn bounds in the inspector
@onready var _bounds_rect := $Node/BoundsDelimiter


func _ready():
	SignalManager.new_file.connect(_on_new_file)


func _on_new_file(file_type):
	
	var file_pos = _get_position_within_bounds()
	var new_file
	match file_type:
		Global.FileTypes.NORMAL:
			new_file = file_scene.instantiate()
		Global.FileTypes.INCREASE_SPAWN_EXE:
			new_file = corrupted_files_scene.instantiate()
			new_file.type = Global.FileTypes.INCREASE_SPAWN_EXE
		Global.FileTypes.CORRUPTED_FOLDER:
			new_file = corrupted_files_scene.instantiate()
			new_file.type = Global.FileTypes.CORRUPTED_FOLDER
	
	var files_properties = Global.file_properties[file_type]
	var properties = files_properties[randi() % files_properties.size()]
	
	_create_file(new_file, file_pos, properties)




# --- || INTERNAL || ---

func _create_file(file_instance : DraggableFile, file_pos : Vector2, properties : Dictionary):
	file_instance.position = file_pos
	file_instance.file_size = properties["size"]
	
	_files_holder.add_child(file_instance)
	
	file_instance.text = properties["name"]
	file_instance.set_icon(properties["anim_name"])


## return a position within desktop bounds
func _get_position_within_bounds():
	# TODO: restruct size, because files must not spawn in toolbar space for instance
	var rect = Rect2(_bounds_rect.position, _bounds_rect.size)
	var xx = randf_range(-rect.size.x/2, rect.size.x/2)
	var yy = randf_range(-rect.size.y/2, rect.size.y/2)
	var pos = Vector2(xx, yy)
	
	return pos
