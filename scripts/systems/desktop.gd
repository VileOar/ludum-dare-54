extends Node2D


## TODO: make this a dict in order to hold all file types' scenes
@export var file_scene : PackedScene
@export var increase_spawn_scene : PackedScene
@export var corrupted_folder_scene : PackedScene


## connected to the Spawner's new file signal in main scene
func _on_spawner_new_file(file_type):
	var file_pos = _get_position_within_bounds()
	var new_file
	match file_type:
		Global.FileTypes.NORMAL:
			new_file = file_scene.instantiate()
		Global.FileTypes.INCREASE_SPAWN_EXE:
			new_file = increase_spawn_scene.instantiate()
			new_file.type = Global.FileTypes.INCREASE_SPAWN_EXE
		Global.FileTypes.CORRUPTED_FOLDER:
			new_file = corrupted_folder_scene.instantiate()
			new_file.type = Global.FileTypes.CORRUPTED_FOLDER
	
	create_file(new_file, file_pos)

func create_file(file_instance, file_pos):
	file_instance.position = file_pos
	add_child(file_instance)

## return a position within desktop bounds
func _get_position_within_bounds():
	# TODO: restruct size, because files must not spawn in toolbar space for instance
	var rect = get_viewport_rect()
	var xx = randf_range(-rect.size.x/2, rect.size.x/2)
	var yy = randf_range(-rect.size.y/2, rect.size.y/2)
	var pos = Vector2(xx, yy)
	
	return pos
