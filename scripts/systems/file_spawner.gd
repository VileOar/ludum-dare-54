extends Node


## this signal is emitted periodically with a file type
## the desktop should be in charge of actually creating the file node and randomly populating it
signal new_file(file_type)

@onready var spawn_timer = $SpawnTimer

## if this variable is true, spawn files periodically
var enable_spawning : bool = true:
	set(value):
		if value:
			spawn_timer.start(spawn_time)
		else:
			spawn_timer.stop()

var spawn_time = 1.0 # sec


func _on_spawn_timer_timeout():
	# TODO: another way to choose file type, not completely random
	var values = Global.FileTypes.values()
	var type = values[randi() % values.size()]
	
	new_file.emit(type)
	
	spawn_timer.start(spawn_time)
