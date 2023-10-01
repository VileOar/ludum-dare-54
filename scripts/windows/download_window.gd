extends DraggableWindow
class_name DownloadWindow


@onready var download_button : Button = $PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/Button
@onready var progress_timer : Timer = $Timer
@onready var download_bar : ProgressBar = $PanelContainer/VBoxContainer/MarginContainer2/VBoxContainer/ProgressBar

var download_increment := 1 # value to increment progress
var files_to_download := 10 # files that will spawn at the end of download

	
func _on_button_pressed():
	download_button.disabled = true
	window_text.text = "Downloading..."

	download_bar.visible = true
	close_button.disabled = true
	progress_timer.start()


func _on_timer_timeout():
	download_bar.value = download_bar.value + download_increment
	
	if download_bar.value >= download_bar.max_value:
		progress_timer.stop()
		
		SignalManager.explode_files.emit(position, files_to_download)
		self.queue_free()
