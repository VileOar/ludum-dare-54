## this is the base for all effect files
extends DraggableFile
class_name EvilFile

var type : Global.FileTypes

func _ready():
	super._ready()
	_anim.modulate = Global.CORRUPTED_COLOUR
