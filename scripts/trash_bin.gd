extends DraggableFile

var mouse_hovered := false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.release_file.connect(remove_file)
	SignalManager.release_files.connect(remove_files)

func remove_file(file : Node2D):
	if file.name == "TrashBin" or not mouse_hovered: return
	file.queue_free()

func remove_files(files : Array):
	for i in range(files.size() - 1, -1, -1):
		var file = files[i]
		remove_file(file)
	Global.selected_files = []

func _on_area_2d_mouse_entered():
	mouse_hovered = true


func _on_area_2d_mouse_exited():
	mouse_hovered = false
