extends ErrorExeFile
class_name DownloadSpawnerFile

func _ready():
	super._ready()


func on_timer_end():
	if DownloadWindow.download_exist_counter <= 0:
		SignalManager.new_window.emit(Global.WindowTypes.DOWNLOAD, Vector2.ZERO)
