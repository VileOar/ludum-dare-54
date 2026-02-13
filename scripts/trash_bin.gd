extends DraggableFile

@onready var deleting_time := $DeletingTime
@onready var _trash_audio := $EmptyTrashAudio
@onready var _trash_file_audio := $TrashFileAudio
@onready var _trash_area = $Area2D

var mouse_hovered := false

var allow_empty := true

## total space from deleted files[br]
## is reset when trash is emptied
var total_space := 0:
	set(val):
		total_space = val
		if val == 0:
			_anim.play("trash_bin_empty")
		elif val < Global.MAX_TRASH_SPACE:
			_anim.play("trash_bin_mid")
		else:
			_anim.play("trash_bin_full")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.release_files.connect(remove_files)
	SignalManager.empty_trash.connect(empty_trash)
	SignalManager.after_recycle_time.connect(after_recycle_time)
	
	can_recycle = false
	can_antivirus = false

# TODO makes trash work in 4.6
func _process(delta):
	if _is_mouse_over():
		mouse_hovered = true
	else:
		mouse_hovered = false
	pass


# Is the mouse currently on top of a specific physics object (trash area)?”
func _is_mouse_over() -> bool:
	# ask the physics engine what’s at a certain position
	var space_state = get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	# physics objects that exist exactly where the mouse is
	query.position = get_global_mouse_position()
	# sets query to detect area 2D but not bodies (static, rigid)
	query.collide_with_areas = true
	query.collide_with_bodies = false

	# gets an  array of all colliders under that point
	var result = space_state.intersect_point(query)

	# checks if mouse is over trash area
	for hit in result:
		if hit.collider == _trash_area:
			return true

	return false


func _remove_file(file : DraggableFile):
	if file.name == "TrashBin" or not file.can_recycle:
		if not file.can_recycle:
			file.play_error_anim()
		return
	total_space += file.file_size
	file.delete()
	_trash_file_audio.play()


func remove_files(files : Array):
	if mouse_hovered and not selected and allow_empty:
		for i in range(files.size() - 1, -1, -1):
			var file = files[i]
			_remove_file(file)


func empty_trash():
	if allow_empty and total_space > 0:
		allow_empty = false
		_anim.play("trash_bin_disabled")
		SignalManager.new_window.emit(Global.WindowTypes.RECYCLING, total_space)


func after_recycle_time():
	SignalManager.free_space.emit(total_space)
	total_space = 0
	allow_empty = true
	_trash_audio.play()


func _on_area_2d_mouse_entered():
	mouse_hovered = true
	pass


func _on_area_2d_mouse_exited():
	mouse_hovered = false
	pass
