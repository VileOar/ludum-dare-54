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

## should only be set by desktop
var bounds_rect : Rect2


const EXPLODE_SPEED = 480.0
const CORRUPTED_COLOUR = "ffe0f3"

const file_properties = {
	FileTypes.NORMAL: [
		{
			"name" : "CC.png",
			"size" : 10,
			"anim_name": "png"
		},
		{
			"name" : "TODO.txt",
			"size" : 2,
			"anim_name": "txt"
		},
	],
	FileTypes.INCREASE_SPAWN_EXE: [
		{
			"name" : "CC.exe",
			"size" : 2,
			"anim_name": "exe"
		},
	],
	FileTypes.CORRUPTED_FOLDER: [
		{
			"name" : "CC onlyfans",
			"size" : 24,
			"anim_name": "folder"
		},
	]
}
