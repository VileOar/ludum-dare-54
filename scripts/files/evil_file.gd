## this is the base for all effect files
extends DraggableFile
class_name EvilFile

var type : Global.FileTypes

func _ready():
	super._ready()
	_anim.modulate = Global.CORRUPTED_COLOUR


func disable_effects():
	can_recycle = true
	can_antivirus = true
	_anim.modulate = Color.WHITE
	_custom_disable_effects()


## this function should be overridden by child classes
func _custom_disable_effects():
	push_error("Not overridden")
