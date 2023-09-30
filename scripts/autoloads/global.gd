extends Node

var selected_files : Array = []
var ignore_inputs := false

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

const FILE_TYPES_WEIGHTS = {
	FileTypes.NORMAL : 4,
	FileTypes.INCREASE_SPAWN_EXE : 1,
	FileTypes.CORRUPTED_FOLDER : 1
}

## should only be set by desktop
var bounds_rect : Rect2

const EXPLODE_SPEED = 480.0

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

func sum_array(array : Array):
	var sum = 0
	for i in array:
		sum += i
	return sum
