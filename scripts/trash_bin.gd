extends DraggableFile

@onready var deleting_time := $DeletingTime
@onready var _trash_audio := $EmptyTrashAudio
@onready var _trash_file_audio := $TrashFileAudio

var mouse_hovered := false

var allow_empty := true

## total space from deleted files[br]
## is reset when trash is emptied
# TODO: add some visual indication of size or how full it is
var total_space := 0:
	set(val):
		total_space = val
		if val == 0:
			_anim.play("trash_bin_empty")
		elif val < Global.MAX_TRASH_SPACE:
			_anim.play("trash_bin_mid")
		else:
			_anim.play("trash_bin_full")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.release_files.connect(remove_files)
	SignalManager.empty_trash.connect(empty_trash)
	SignalManager.after_recycle_time.connect(after_recycle_time)
	
	can_recycle = false
	can_antivirus = false


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
	if allow_empty and total_space > 0:
		allow_empty = false
		_anim.play("trash_bin_disabled")
		SignalManager.free_space.emit(total_space)


func after_recycle_time():
	total_space = 0
	allow_empty = true
	_trash_audio.play()


func _on_area_2d_mouse_entered():
	mouse_hovered = true


func _on_area_2d_mouse_exited():
	mouse_hovered = false
