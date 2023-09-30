extends Node

var selected_files : Array = []

func _ready():
	randomize()


enum FileTypes {
	NORMAL, ## a simple file with no gimmicks
	INCREASE_SPAWN_EXE, ## increase the spawn rate considerably
	CORRUPTED_FOLDER, ## "explodes" in several files when deleted
#	ERROR_MESSAGE_EXE, ## infintely spawns error messages
#	ADD_POPUP_EXE, ## spawns an add popup
	# TODO: add more as needed
}
