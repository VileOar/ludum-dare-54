extends DraggableFile


var mouse_hovered := false

## total space from deleted files[br]
## is reset when trash is emptied
# TODO: add some visual indication of size or how full it is
var total_space := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.release_file.connect(remove_file)
	SignalManager.release_files.connect(remove_files)
	SignalManager.empty_trash.connect(empty_trash)

func remove_file(file : DraggableFile):
	if file.name == "TrashBin" or not mouse_hovered: return
	total_space += file.file_size
	file.delete()

func remove_files(files : Array):
	for i in range(files.size() - 1, -1, -1):
		var file = files[i]
		remove_file(file)
	Global.selected_files = []

func empty_trash():
	# TODO: according to how full it is, lag the computer (this should probably be done by emitting
	# a signal to trigger lag which is handled somewhere else, since it involves blocing player
	# input, giving UI feedback, ...)
	SignalManager.free_space.emit(total_space)
	total_space = 0


func _on_area_2d_mouse_entered():
	mouse_hovered = true


func _on_area_2d_mouse_exited():
	mouse_hovered = false
