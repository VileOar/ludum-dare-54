extends DraggableFile


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.release_file.connect(remove_file)

func remove_file(file : Node2D):
	if file.name == "TrashBin": return
	file.queue_free()
