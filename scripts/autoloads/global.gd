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



const file_properties = {
	FileTypes.NORMAL: [
		{
			"name" : "CC.png",
			"size" : 10
		},
	],
	FileTypes.INCREASE_SPAWN_EXE: [
		{
			"name" : "CC.exe",
			"size" : 2
		},
	],
	FileTypes.CORRUPTED_FOLDER: [
		{
			"name" : "CC onlyfans",
			"size" : 24
		},
	]
}
