extends Node


@onready var spawn_timer = $SpawnTimer
@onready var spawn_rate_timer = $SpawnRateTimer

func _ready():
	SignalManager.change_spawn_time.connect(change_spawn_time)
	SignalManager.explode_folder.connect(create_files)

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
	
	SignalManager.new_file.emit(type)
	
	spawn_timer.start(spawn_time)

func change_spawn_time(time):
	spawn_time = time
	spawn_rate_timer.start(3.0)


func create_files(quantity):
	var values = Global.FileTypes.values()
	for i in range(quantity):
		var type = values[randi() % values.size()]
		SignalManager.new_file.emit(type)


func _on_spawn_rate_timer_timeout():
	spawn_time = 1.0
