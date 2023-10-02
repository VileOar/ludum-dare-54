extends ErrorExeFile
class_name RecursiveSpawnerFile

static var exist_counter := 0


func _ready():
	super._ready()
	exist_counter += 1


func _notification(what):
	super._notification(what)
	match what:
		NOTIFICATION_PREDELETE:
			exist_counter = max(exist_counter - 1, 0)
