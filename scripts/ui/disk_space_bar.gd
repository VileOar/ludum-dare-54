extends Control
class_name DiskSpaceBar

@export var boom_scene : PackedScene

var _initial_bar_size : Vector2

var _disk_bar_shake_strength = 0.0

# lowest value from which bar starts increasing in size
const _MIN_BAR_GROW_PERCENT = 0.6
const _MAX_BAR_SIZE_SCALE = 1.4

const _MAX_RUMBLE_TIME = 0.5

@onready var scale_slope = (_MAX_BAR_SIZE_SCALE - 1.0) / (1.0 - _MIN_BAR_GROW_PERCENT)
@onready var scale_offset = _MAX_BAR_SIZE_SCALE - scale_slope

@onready var _space_bar = $DiskSpaceBar
@onready var _timer = $Timer

const COLOR_NORMAL = Color("65dcd6")
const COLOR_MID = Color("e8bc50")
const COLOR_BAD = Color("d85525")


func _ready():
	_initial_bar_size = _space_bar.size


func set_shake(strength : float):
	_disk_bar_shake_strength = strength


func spawn_boom():
	var boom_anim = boom_scene.instantiate()
	boom_anim.position.x = randf_range(position.x, position.x + size.x)
	boom_anim.position.y = randf_range(position.y, position.x + size.y)
	boom_anim.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(boom_anim)


func play_game_over_anim():
	_timer.stop()
	$AnimationPlayer.play("game_over")
	
func play_defeat_sfx():
	SignalManager.play_game_over_sfx.emit()


func _physics_process(_delta):
	if _disk_bar_shake_strength > 0:
		var angle = randf() * 2 * PI
		_space_bar.position = Vector2.RIGHT.rotated(angle) * _disk_bar_shake_strength


func set_disk_space(current_space : float, max_space : float):
	var last_value = _space_bar.max_value
	
	_space_bar.min_value = 0
	_space_bar.max_value = max_space
	_space_bar.value = current_space
	
	var percent = current_space / max_space
	if percent >= _MIN_BAR_GROW_PERCENT:
		_set_progressbar_size(percent * scale_slope + scale_offset)
	else:
		#_set_progressbar_size(1.0)
		set_progressbar_to_default_size()
	
	if current_space < last_value:
		_disk_bar_shake_strength = percent * 4
		_timer.start(min(_MAX_RUMBLE_TIME, _MAX_RUMBLE_TIME * (percent + 0.2)))
	
	_set_shake(percent)
	_set_color(percent)
	
	
func set_progressbar_to_default_size():
	_space_bar.custom_minimum_size = _initial_bar_size


func _set_progressbar_size(size_scale):
	size_scale = min(size_scale, _MAX_BAR_SIZE_SCALE)
#	_space_bar.custom_minimum_size = size_scale * _initial_bar_size
#	custom_minimum_size = _space_bar.custom_minimum_size

func _set_shake(percent) -> void:
	if percent < 0.4:
		_disk_bar_shake_strength = 0

func _set_color(percent):
	if percent < 0.4:
		_space_bar.modulate = COLOR_NORMAL
	elif percent < 0.8:
		_space_bar.modulate = COLOR_MID
	else:
		_space_bar.modulate = COLOR_BAD


func _on_timer_timeout():
	_disk_bar_shake_strength = 0.0
