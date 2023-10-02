extends DraggableWindow
class_name RecursiveWindow

	
func _on_reject_button_pressed():
	play_click_sfx()
	await _click_sfx.finished
	self.queue_free()


func _on_accept_button_pressed():
	play_click_sfx()
	await _click_sfx.finished
	SignalManager.new_window.emit(Global.WindowTypes.RECURSIVE, position)
