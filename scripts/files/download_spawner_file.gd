extends ErrorExeFile
class_name DownloadSpawnerFile

func on_timer_end():
	if DownloadWindow.exist_counter <= 0:
		SignalManager.new_window.emit(Global.WindowTypes.DOWNLOAD, Vector2.ZERO)
