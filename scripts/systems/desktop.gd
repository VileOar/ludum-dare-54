extends Node2D


## TODO: make this a dict in order to hold all file types' scenes
@export var file_scene : PackedScene

var selected_files : Array = []

## connected to the Spawner's new file signal in main scene
func _on_spawner_new_file(file_type):
	match file_type:
		Global.FileTypes.NORMAL:
			var file_pos = _get_position_within_bounds()
			var new_file = file_scene.instantiate()
			new_file.position = file_pos
			add_child(new_file)


## return a position within desktop bounds
func _get_position_within_bounds():
	# TODO: restruct size, because files must not spawn in toolbar space for instance
	var rect = get_viewport_rect()
	var xx = randf_range(-rect.size.x/2, rect.size.x/2)
	var yy = randf_range(-rect.size.y/2, rect.size.y/2)
	var pos = Vector2(xx, yy)
	
	return pos


func _on_mouse_manager_select_files(files):
	# TODO: drag any file should apply to those as well
	selected_files = files
