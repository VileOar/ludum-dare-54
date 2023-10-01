extends DraggableFile

@onready var deleting_time := $DeletingTime
@onready var _trash_audio := $EmptyTrashAudio
@onready var _trash_file_audio := $TrashFileAudio

var mouse_hovered := false

## total space from deleted files[br]
## is reset when trash is emptied
# TODO: add some visual indication of size or how full it is
var total_space := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.release_files.connect(remove_files)
	SignalManager.empty_trash.connect(empty_trash)
	SignalManager.after_recycle_time.connect(after_recycle_time)


func _remove_file(file : DraggableFile):
	if file.name == "TrashBin" or not file.can_recycle:
		if not file.can_recycle:
			file.play_error_anim()
		return
	total_space += file.file_size
	file.delete()
	_trash_file_audio.play()


func remove_files(files : Array):
	if mouse_hovered and not selected:
		for i in range(files.size() - 1, -1, -1):
			var file = files[i]
			_remove_file(file)


func empty_trash():

	#TODO: only deactivate trash bin while recycling, instead of the whole input system
	#deleting_time.start()
	#Global.ignore_inputs = true
	#Global.ignore_inputs = false
	
	SignalManager.free_space.emit(total_space)
	
	
func after_recycle_time():
	total_space = 0
	_trash_audio.play()
	print("recycled!!")


func _on_area_2d_mouse_entered():
	mouse_hovered = true


func _on_area_2d_mouse_exited():
	mouse_hovered = false
