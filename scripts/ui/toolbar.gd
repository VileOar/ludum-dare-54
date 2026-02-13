extends Control
class_name Toolbar

@onready var _click_sfx := $ClickSFX
@onready var _hover_sfx := $HoverSFX
@onready var _delete_all_windows_sfx := $DeleteAllWindowsSFX
@onready var _install_hard_drive_sfx := $InstallHardDriveSFX
@onready var _delete_system32_sfx := $DeleteSystem32SFX

@onready var disk_space_label := %DiskSpaceLabel
@onready var pause_menu := %PauseMenu
@onready var blocker := $Blocker

@onready var time_label := %Time
@onready var date_label := %Date

@onready var diskbar = %Diskbar

@onready var _power1_btn := %Power1Button
@onready var _power2_btn := %Power2Button
@onready var _power3_btn := %Power3Button


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
	if diskbar:
		diskbar.set_disk_space(new_space, max_space)
	else:
		print("[Warning] DiskBar does not exist yet.")


func _play_click_sfx():
	_click_sfx.play()
	
func _on_mouse_enter_play_hover_sfx():
	_hover_sfx.play()

func _on_empty_button_pressed():
	_play_click_sfx()
	SignalManager.empty_trash.emit()

func _on_start_button_pressed():
	_play_click_sfx()
	if pause_menu.visible:
		pause_menu.hide()
		blocker.hide()
	else:
		pause_menu.show()
		blocker.show()


func _on_logoff_button_pressed():
	_play_click_sfx()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_shutdown_button_pressed():
	_play_click_sfx()
	get_tree().quit()
	


func _on_power_1_button_pressed():
	SignalManager.delete_all_windows.emit()
	_delete_all_windows_sfx.play()
	_power1_btn.disabled = true
	_on_start_button_pressed()


func _on_power_2_button_pressed():
	_install_hard_drive_sfx.play()
	Global.set_max_space(Global.MAX_DISK_SPACE * 2)
	_power2_btn.disabled = true
	_on_start_button_pressed()


func _on_power_3_button_pressed():
	_delete_system32_sfx.play()
	SignalManager.toggle_distortion.emit(true)
	SignalManager.free_space.emit(Global.MAX_DISK_SPACE * 0.5)
	_power3_btn.disabled = true
	_on_start_button_pressed()
