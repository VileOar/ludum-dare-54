extends Control
class_name Toolbar

@onready var disk_space_bar := %DiskSpaceBar
@onready var disk_space_label := %DiskSpaceLabel

@onready var antivirus_panel := %AntivirusPanel


func _on_disk_space_manager_space_update(new_space, max_space):
	# TODO: change colour (and animation?) according to space occupied
	disk_space_bar.max_value = max_space
	disk_space_bar.min_value = 0
	disk_space_bar.value = new_space
	
	disk_space_label.text = str(max_space - new_space) + " free out of " + str(max_space)


func _on_empty_button_pressed():
	SignalManager.empty_trash.emit()


func _on_anti_v_button_pressed():
	if antivirus_panel.visible:
		antivirus_panel.hide()
	else:
		antivirus_panel.show()
