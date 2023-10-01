extends EvilFile
class_name ErrorExeFile

const SPAWN_ERROR_TIME = 7.0
const MESSAGE_OFFSET = 64.0
const COLUMN_INTERVAL = 128.0

@onready var _spawn_error_timer := $SpawnErrorTimer

var _first_position : Vector2
var _next_position : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	can_recycle = false
	can_antivirus = true
	_spawn_error_timer.start(SPAWN_ERROR_TIME)
	_first_position = Global.bounds_rect.position + Vector2.ONE * MESSAGE_OFFSET
	_next_position = _first_position


func _custom_disable_effects():
	_spawn_error_timer.stop()


func _on_spawn_error_timer_timeout():
	var _rect_size = Global.bounds_rect.size
	
	_next_position = Vector2(randf_range(-1, 1) * int(_rect_size.x), randf_range(-1, 1) * int(_rect_size.y))
	SignalManager.new_window.emit(Global.WindowTypes.NORMAL, _next_position)

	_spawn_error_timer.start(SPAWN_ERROR_TIME / Global.current_wave) 
