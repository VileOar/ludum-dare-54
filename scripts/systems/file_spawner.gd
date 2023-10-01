extends Node


@onready var spawn_timer = $SpawnTimer
@onready var spawn_modifier_timer = $SpawnModifierTimer
@onready var waves_timer : Timer = $WavesTimer

## In seconds. Defines spawn time per wave.
const WAVE_RATE = {
	1 : 2.0,
	2 : 1.5,
	3 : 1.2,
	4 : 1,
	5 : 0.9
}
var spawn_time


## if this variable is true, spawn files periodically
var enable_spawning : bool = true:
	set(value):
		enable_spawning = value
		if value:
			spawn_timer.start(WAVE_RATE[Global.current_wave])
		else:
			spawn_timer.stop()

var values := Global.FileTypes.values()
var weights := Global.FILE_TYPES_WEIGHTS


func _ready():
	SignalManager.change_spawn_time.connect(change_spawn_time)
	spawn_time = WAVE_RATE[Global.current_wave]

	waves_timer.start(Global.WAVE_TIMES[Global.current_wave])


func _on_spawn_timer_timeout():
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
	spawn_time = WAVE_RATE[Global.current_wave]
	spawn_timer.start(spawn_time)


func change_spawn_time(time, modifier_duration):
	spawn_time = time
	spawn_modifier_timer.start(modifier_duration)


func _on_spawn_modifier_timer_timeout():
	spawn_time = WAVE_RATE[Global.current_wave]


func _on_waves_timer_timeout():
	if Global.current_wave >= Global.WAVE_TIMES.size():
		waves_timer.stop()
	else:	
		Global.current_wave += 1
		print(Global.current_wave)
		waves_timer.start(Global.WAVE_TIMES[Global.current_wave])
