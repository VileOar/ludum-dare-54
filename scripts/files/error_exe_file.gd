extends EvilFile
class_name ErrorExeFile

const SPAWN_ERROR_TIME = 4.0
const MESSAGE_OFFSET = 64.0
const COLUMN_INTERVAL = 128.0

@onready var _spawn_error_timer := $SpawnErrorTimer

var _last_column_multiplier = 0
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


func _on_spawn_error_timer_timeout():
	SignalManager.new_window.emit(Global.WindowTypes.NORMAL, _next_position)
	_next_position += Vector2(-1, 1) * MESSAGE_OFFSET
	# if position not in bounds, go to next column
	if not Global.bounds_rect.has_point(_next_position):
		_last_column_multiplier += 1
		_next_position = Vector2(_first_position.x + _last_column_multiplier * COLUMN_INTERVAL, _first_position.y)
		
		# if point is still not in bounds (because, column is too far), restart from first_position
		if not Global.bounds_rect.has_point(_next_position):
			_next_position = _first_position
	
	_spawn_error_timer.start(SPAWN_ERROR_TIME)
