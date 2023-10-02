extends Node
class_name DiskSpaceManager


signal space_update(new_space, max_space)

var disk_space := 0


func _ready():
	SignalManager.file_created.connect(_on_file_created)
	SignalManager.free_space.connect(_on_free_space)


func _add_disk_space(to_add):
	disk_space += to_add
	space_update.emit(disk_space, Global.MAX_DISK_SPACE)
	if disk_space > Global.MAX_DISK_SPACE:
		SignalManager.disk_full.emit()


func _on_file_created(file : DraggableFile):
	_add_disk_space(file.file_size)


func _on_free_space(size : float):
	# add negative to remove
	_add_disk_space(-size)
