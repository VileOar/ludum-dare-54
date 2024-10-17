extends Control
class_name BootScreen

@onready var _progress_bar = %ProgressBar
@onready var _progress_label = %ProgressLabel

@export var value: float:
	set(val):
		value = val
		_progress_bar.value = val
		_progress_label.value = val

