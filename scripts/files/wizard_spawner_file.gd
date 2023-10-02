extends ErrorExeFile
class_name WizardSpawnerFile

var has_spawned_window = false


func _ready():
	super._ready()


func on_timer_end():
	if !has_spawned_window:
		has_spawned_window = true
		SignalManager.new_window.emit(Global.WindowTypes.WIZARD, Vector2.ZERO)
