extends Node


@onready var spawn_timer = $SpawnTimer
@onready var spawn_rate_timer = $SpawnRateTimer

func _ready():
	SignalManager.change_spawn_time.connect(change_spawn_time)

## if this variable is true, spawn files periodically
var enable_spawning : bool = true:
	set(value):
		if value:
			spawn_timer.start(spawn_time)
		else:
			spawn_timer.stop()

var spawn_time = 1.0 # sec


func _on_spawn_timer_timeout():
	var values = Global.FileTypes.values()
	var weights := Global.FILE_TYPES_WEIGHTS
	var sum = Global.sum_array(weights.values())
	var result = randi() % sum + 1

	var type
	sum = 0
	for key in weights:
		type = key
		sum += weights[key]
		if result <= sum:
			break
	
	SignalManager.new_file.emit(type)
	
	spawn_timer.start(spawn_time)

func change_spawn_time(time):
	spawn_time = time
	spawn_rate_timer.start(3.0)


func _on_spawn_rate_timer_timeout():
	spawn_time = 1.0
