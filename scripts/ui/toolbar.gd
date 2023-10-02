extends Control
class_name Toolbar

@onready var _click_sfx := $ClickSFX
@onready var _hover_sfx := $HoverSFX

@onready var disk_space_label := %DiskSpaceLabel
@onready var pause_menu := %PauseMenu
@onready var blocker := $Blocker

@onready var time_label := %Time
@onready var date_label := %Date

@onready var diskbar := %Diskbar as DiskSpaceBar


func _ready():
	SignalManager.disk_full.connect(_on_disk_full)


func _on_disk_full():
	diskbar.play_game_over_anim()


func _physics_process(_delta):
	var time = Time.get_datetime_dict_from_system()
	time_label.text = "%02d:%02d" % [time["hour"], time["minute"]]
	date_label.text = "%02d/%02d/%02d" % [time["year"], time["month"], time["day"]]


func _on_disk_space_manager_space_update(new_space : float, max_space : float):
	disk_space_label.text = str(max_space - new_space) + " free out of " + str(max_space)
	
	diskbar.set_disk_space(new_space, max_space)

func _play_click_sfx():
	_click_sfx.play()
	
func _on_mouse_enter_play_hover_sfx():
	_hover_sfx.play()

func _on_empty_button_pressed():
	_play_click_sfx()
	SignalManager.empty_trash.emit()

func _on_start_button_pressed():
	_play_click_sfx()
	if get_tree().paused:
		get_tree().paused = false
		pause_menu.hide()
		blocker.hide()
	else:
		get_tree().paused = true
		pause_menu.show()
		blocker.show()


func _on_logoff_button_pressed():
	_play_click_sfx()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_shutdown_button_pressed():
	_play_click_sfx()
	get_tree().quit()
	
