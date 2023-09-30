extends Node


func _ready():
	randomize()


enum FileTypes {
	NORMAL, ## a simple file with no gimmicks
#	ERROR_MESSAGE_EXE, ## infintely spawns error messages
#	ADD_POPUP_EXE, ## spawns an add popup
	# TODO: add more as needed
}
