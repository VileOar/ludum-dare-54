extends DraggableWindow
class_name DownloadWindow

## how many of these there are
static var exist_counter = 0

@onready var download_button : Button = %DownloadButton
@onready var progress_timer : Timer = $Timer
@onready var download_bar : ProgressBar = %DownloadProgress

@onready var top := $VBoxContainer

var download_increment := 1 # value to increment progress
var files_to_download := 10 # files that will spawn at the end of download


func _ready():
	exist_counter += 1


func _physics_process(delta):
	super._physics_process(delta)
	var rect = Rect2(top.global_position, top.size)
	var mouse_pos = get_global_mouse_position()
	# this check is necessary because this signal is fired when hovering into children of this control
	if not rect.has_point(mouse_pos):
		global_position = mouse_pos


func _notification(what):
	match what:
		NOTIFICATION_PREDELETE:
			exist_counter = max(exist_counter - 1, 0)


func _on_button_pressed():
	download_button.disabled = true
	window_text.text = "Downloading..."

	download_bar.visible = true
	close_button.disabled = true
	progress_timer.start()
	play_click_sfx()


func _on_timer_timeout():
	download_bar.value = download_bar.value + download_increment
	
	if download_bar.value >= download_bar.max_value:
		progress_timer.stop()
		
		SignalManager.explode_files.emit(position, files_to_download)
		self.queue_free()
