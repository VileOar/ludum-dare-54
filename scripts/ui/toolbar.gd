extends Control
class_name Toolbar

## used so that disk bar can be moved freely
@onready var bar_anchor := %BarAnchor
@onready var disk_space_bar := %DiskSpaceBar

@onready var disk_space_label := %DiskSpaceLabel
@onready var pause_menu := %PauseMenu
@onready var blocker := $Blocker

@onready var _rumble_timer := $RumbleTimer

@onready var time_label := %Time
@onready var date_label := %Date

var _initial_bar_size : Vector2

var _disk_bar_shake_strength = 0.0

# lowest value from which bar starts increasing in size
const _MIN_BAR_GROW_PERCENT = 0.6
const _MAX_BAR_SIZE_SCALE = 1.5

const _MAX_RUMBLE_TIME = 0.5

@onready var m = (_MAX_BAR_SIZE_SCALE - 1.0) / (1.0 - _MIN_BAR_GROW_PERCENT)
@onready var b = _MAX_BAR_SIZE_SCALE - m


func _ready():
	_initial_bar_size = disk_space_bar.size


func _physics_process(_delta):
	var time = Time.get_datetime_dict_from_system()
	time_label.text = "%02d:%02d" % [time["hour"], time["minute"]]
	date_label.text = "%02d/%02d/%02d" % [time["year"], time["month"], time["day"]]
	
	if _disk_bar_shake_strength > 0:
		var angle = randf() * 2 * PI
		disk_space_bar.position = Vector2.RIGHT.rotated(angle) * _disk_bar_shake_strength


func _on_disk_space_manager_space_update(new_space : float, max_space : float):
	# TODO: change colour (and animation?) according to space occupied
	disk_space_bar.max_value = max_space
	disk_space_bar.min_value = 0
	disk_space_bar.value = new_space
	
	disk_space_label.text = str(max_space - new_space) + " free out of " + str(max_space)
	
	var percent = new_space / max_space
	if percent >= _MIN_BAR_GROW_PERCENT:
		_set_progressbar_size(percent * m + b)
	else:
		_set_progressbar_size(1.0)
	_disk_bar_shake_strength = percent * 4
	_rumble_timer.start(min(_MAX_RUMBLE_TIME, _MAX_RUMBLE_TIME * (percent + 0.2)))


func _set_progressbar_size(size_scale):
	disk_space_bar.custom_minimum_size = size_scale * _initial_bar_size
	bar_anchor.custom_minimum_size = disk_space_bar.custom_minimum_size


func _on_empty_button_pressed():
	SignalManager.empty_trash.emit()


func _on_anti_v_button_pressed():
	SignalManager.toggle_antivirus.emit()


func _on_start_button_pressed():
	if get_tree().paused:
		get_tree().paused = false
		pause_menu.hide()
		blocker.hide()
	else:
		get_tree().paused = true
		pause_menu.show()
		blocker.show()


func _on_logoff_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_shutdown_button_pressed():
	get_tree().quit()


func _on_rumble_timer_timeout():
	_disk_bar_shake_strength = 0.0
