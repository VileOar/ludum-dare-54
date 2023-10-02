extends Node
class_name DiskSpaceManager


signal space_update(new_space, max_space)

var disk_space := 0
var is_disk_almost_full := false


func _ready():
	SignalManager.file_created.connect(_on_file_created)
	SignalManager.free_space.connect(_on_free_space)


func _add_disk_space(to_add):
	disk_space += to_add
	space_update.emit(disk_space, Global.MAX_DISK_SPACE)
	if disk_space > Global.MAX_DISK_SPACE:
		SignalManager.disk_full.emit()
		get_tree().change_scene_to_file("res://scenes/ui/blue_screen.tscn")
	
	# When disk is almost full signals
	if disk_space > Global.MAX_DISK_SPACE * Global.DISK_ALMOST_FULL_PERCENTAGE and !is_disk_almost_full:
		SignalManager.disk_almost_full.emit()
		is_disk_almost_full = true
	if disk_space <= Global.MAX_DISK_SPACE * Global.DISK_ALMOST_FULL_PERCENTAGE:
		is_disk_almost_full = false



func _on_file_created(file : DraggableFile):
	_add_disk_space(file.file_size)


func _on_free_space(size : float):
	# add negative to remove
	_add_disk_space(-size)
