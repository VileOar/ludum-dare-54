extends DraggableWindow
class_name RecursiveWindow

	
func _on_reject_button_pressed():
	self.queue_free()


func _on_accept_button_pressed():
	SignalManager.new_window.emit(Global.WindowTypes.RECURSIVE, position)
