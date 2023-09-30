extends DraggableFile

var mouse_hovered := false

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.release_file.connect(remove_file)

func remove_file(file : Node2D):
	if file.name == "TrashBin" or not mouse_hovered: return
	file.queue_free()

func _on_area_2d_mouse_entered():
	mouse_hovered = true


func _on_area_2d_mouse_exited():
	mouse_hovered = false
