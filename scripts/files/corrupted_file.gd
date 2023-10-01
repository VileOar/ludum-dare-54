extends EvilFile
class_name CorruptedFile

const EXPLODE_QUANTITY = 3
const RATE_MODIFIER = 0.2  ## in seconds
const MODIFIER_DUARATION = 3.0

var effects_on = true


func _ready():
	super._ready()
	can_recycle = true
	can_antivirus = true


func _custom_disable_effects():
	effects_on = false


func delete():
	if effects_on:
		match type:
			Global.FileTypes.INCREASE_SPAWN_EXE:
				increase_spawn_rate()
			Global.FileTypes.CORRUPTED_FOLDER:
				explode_files()
	queue_free()


## Increase Spawn
func increase_spawn_rate():
	SignalManager.change_spawn_time.emit(RATE_MODIFIER, MODIFIER_DUARATION)


## Explode Files
func explode_files():
	SignalManager.explode_files.emit(global_position, EXPLODE_QUANTITY * Global.current_wave / 2)
