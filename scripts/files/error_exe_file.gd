extends EvilFile
class_name ErrorExeFile

const SPAWN_ERROR_TIME = 7.0

@onready var _spawn_error_timer := $SpawnErrorTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	can_recycle = false
	can_antivirus = true
	_spawn_error_timer.start(SPAWN_ERROR_TIME)


func _custom_disable_effects():
	_spawn_error_timer.stop()


func _on_spawn_error_timer_timeout():
	if DraggableWindow.exist_counter < Global.MAX_WINDOWS:
		on_timer_end()
	
	_spawn_error_timer.start(SPAWN_ERROR_TIME - (Global.current_wave * 0.7)) 


func on_timer_end():
	SignalManager.new_window.emit(Global.WindowTypes.NORMAL, Vector2.ZERO)
