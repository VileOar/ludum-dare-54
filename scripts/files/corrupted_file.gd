extends EvilFile
class_name CorruptedFile

const EXPLODE_QUANTITY = 10


func _ready():
	super._ready()
	can_recycle = true
	can_antivirus = true


func delete():
	match type:
		Global.FileTypes.INCREASE_SPAWN_EXE:
			increase_spawn_rate()
		Global.FileTypes.CORRUPTED_FOLDER:
			explode_files()
	queue_free()

## Increase Spawn
func increase_spawn_rate():
	SignalManager.change_spawn_time.emit(0.2)

## Explode Files
func explode_files():
	SignalManager.explode_files.emit(global_position, EXPLODE_QUANTITY)
