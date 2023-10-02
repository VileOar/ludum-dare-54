extends Control
class_name Antivirus

@onready var _quarantine_grid = %QuarantineGrid
@onready var _grid_detector = %Area2D
@onready var _purge_progressbar = %PurgeProgressbar

# Audio
@onready var _purge_sfx = $PurgeSFX
@onready var _click_sfx = $ClickSFX
@onready var _hover_sfx = $HoverSFX

@onready var _virus_anim := %VirusAnim

var _mouse_hovered := false

var _active := false

## a position way out of screen, where files are sent when they are in quarantine, so I don't have
## to bother with deleting and recreating them if they pop out of quarantine
var _shadow_realm := Vector2(50000, 50000)

## to determine the next file to be replaced
var _quarantine_queue := []
var _max_quarantine_size := 4

var _purge_counter := 0.0
var _purge_speed := 100.0 # %/sec
var _purging := false


func _ready():
	_virus_anim.play("idle")
	SignalManager.release_files.connect(_on_release_files)
	_max_quarantine_size = _quarantine_grid.get_child_count()
	_active = true
	
	SignalManager.new_wave.connect(_virus_code)
	SignalManager.corrupted_file_effect_used.connect(_virus_laugh)
	SignalManager.free_space.connect(_virus_angry) # also on _purge_files()


func _process(delta):
	if _purging:
		_purge_counter += _purge_speed * delta
		_purge_progressbar.value = _purge_counter
		if _purge_counter >= 100.0:
			_purge_files()


func _drop_in_quarantine(file : DraggableFile):
	if not file.can_antivirus:
		file.play_error_anim()
		return
	
	# it pops all stored files until there is a free slot
	while _quarantine_queue.size() > _max_quarantine_size - 1:
		var pop_file := _quarantine_queue.pop_back() as DraggableFile
		_swap_out_file(pop_file)
	
	file.set_disabled(true)
	file.global_position = _shadow_realm
	file.set_lifted(false)
	file.set_selected(false)
	_quarantine_queue.push_front(file)
	
	_update_grid_graphics()


func _swap_out_file(file : DraggableFile):
	file.set_disabled(false)
	file.global_position = _grid_detector.global_position + Vector2(0, -128)
	file.speed = Global.EXPLODE_SPEED
	var angle = randf_range(-PI/4, PI/4)
	file.move_dir = Vector2.UP.rotated(angle)


func _purge_files():
	while _quarantine_queue.size() > 0:
		var file = _quarantine_queue.pop_back() as DraggableFile
		if file is EvilFile:
			# stupid edge case
			if file.get_file_icon_anim() == "badlink":
				file.set_icon("link")
			
			file.disable_effects()
		_swap_out_file(file)
	
	_purge_sfx.play()
	_purging = false
	_purge_counter = 0.0
	_purge_progressbar.value = _purge_counter
	_update_grid_graphics()
	
	_virus_angry(0)


func _update_grid_graphics():
	# update grid graphics
	var first_empty = 0
	for ix in range(_quarantine_queue.size()):
		_quarantine_grid.get_child(ix).set_icon(_quarantine_queue[ix].get_file_icon_anim())
		first_empty += 1
	
	# set remaining as empty
	while first_empty < _quarantine_grid.get_child_count():
		_quarantine_grid.get_child(first_empty).set_icon("")
		first_empty += 1


func _on_release_files(files : Array):
	if _mouse_hovered and _active:
		for i in range(files.size() - 1, -1, -1):
			var file = files[i]
			_drop_in_quarantine(file)


func _on_mouse_enter_play_hover_sfx():
	_hover_sfx.play()
		

func _on_area_2d_mouse_entered():
	_mouse_hovered = true


func _on_area_2d_mouse_exited():
	_mouse_hovered = false


func _on_purge_button_pressed():
	_click_sfx.play()
	if not _quarantine_queue.is_empty():
		_purging = true


func _virus_laugh():
	_virus_switch_anim("laugh")


func _virus_angry(_a):
	_virus_switch_anim("angry")


func _virus_code(_a):
	_virus_switch_anim("code")


func _virus_switch_anim(anim_name):
	if _virus_anim.current_animation == "idle" or not _virus_anim.is_playing():
		_virus_anim.play(anim_name)


func _on_virus_anim_animation_finished(_anim_name):
	_virus_anim.play("idle")
