extends ErrorExeFile
class_name RecursionExeFile

func _on_spawn_error_timer_timeout():
	var _rect_size = Global.bounds_rect.size
	
	_next_position = Vector2(randf_range(-1, 1) * int(_rect_size.x), randf_range(-1, 1) * int(_rect_size.y))
	SignalManager.new_window.emit(Global.WindowTypes.RECURSIVE, _next_position)
	_spawn_error_timer.start(SPAWN_ERROR_TIME / Global.current_wave)
