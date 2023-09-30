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
	FileTypes.NORMAL : 3,
	FileTypes.INCREASE_SPAWN_EXE : 1,
	FileTypes.CORRUPTED_FOLDER : 1
}

## should only be set by desktop
var bounds_rect : Rect2

const EXPLODE_SPEED = 480.0
const CORRUPTED_COLOUR = Color(1, 0.9, 0.9, 1)

func sum_array(array : Array):
	var sum = 0
	for i in array:
		sum += i
	return sum


const file_properties = {
	FileTypes.NORMAL: [
		{
			"name" : "family.png",
			"size" : 10,
			"anim_name": "png"
		},
		{
			"name" : "TODO.txt",
			"size" : 2,
			"anim_name": "txt"
		},
		{
			"name" : "school projects",
			"size" : 20,
			"anim_name": "folder"
		},
		{
			"name" : "bitcoin miner",
			"size" : 14,
			"anim_name": "exe"
		},
		{
			"name" : "TODO.txt",
			"size" : 3,
			"anim_name": "txt"
		},
		{
			"name" : "my photos",
			"size" : 10,
			"anim_name": "folder"
		},
		{
			"name" : "selfie.png",
			"size" : 13,
			"anim_name": "png"
		},
	],
	FileTypes.INCREASE_SPAWN_EXE: [
		{
			"name" : "free v-bucks.exe",
			"size" : 3,
			"anim_name": "exe"
		},
		{
			"name" : "unification.exe",
			"size" : 5,
			"anim_name": "exe"
		},
		{
			"name" : "me.png",
			"size" : 20,
			"anim_name": "png"
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
