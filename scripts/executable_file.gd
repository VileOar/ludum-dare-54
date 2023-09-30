extends DraggableFile

@onready var increase_spawn_timer = $IncreaseSpawnTimer
var type : Global.FileTypes

func delete():
	hide()
	match type:
		Global.FileTypes.INCREASE_SPAWN_EXE:
			increase_spawn_rate()

## Increase Spawn
func increase_spawn_rate():
	SignalManager.change_spawn_time.emit(0.2)
	increase_spawn_timer.start()

func _on_increase_spawn_timer_timeout():
	SignalManager.change_spawn_time.emit(1)
	queue_free()
