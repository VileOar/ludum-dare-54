extends Node

var selected_files : Array = []
var ignore_inputs := false


func _ready():
	randomize()

enum FileTypes {
	NORMAL, ## a simple file with no gimmicks
	INCREASE_SPAWN_EXE, ## increase the spawn rate considerably
	CORRUPTED_FOLDER, ## "explodes" in several files when deleted
	ERROR_MESSAGE_EXE, ## infintely spawns error messages
#	ADD_POPUP_EXE, ## spawns an add popup
	# TODO: add more as needed
}

enum WindowTypes {
	NORMAL, ## a simple window with no gimmicks
	DOWNLOAD, ## can be simply closed or used to download more files
	RECURSIVE, ## spawns a message of the same type if wrong choiced is picked
}

const FILE_TYPES_WEIGHTS = {
	FileTypes.NORMAL : 30,
	FileTypes.INCREASE_SPAWN_EXE : 10,
	FileTypes.CORRUPTED_FOLDER : 10,
	FileTypes.ERROR_MESSAGE_EXE : 3
}

## time in seconds that each wave takes. If -1 then it keeps going forever
const WAVE_TIMES = {
	1 :20,
	2 : 20,
	3 : 30,
	4 : 60,
	5 : -1
}

var current_wave = 1:
	set(value):
		current_wave = value
		if current_wave > WAVE_TIMES.size():
			current_wave = WAVE_TIMES.size()


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
			"name" : "bitcoin_miner.exe",
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
	],
	FileTypes.ERROR_MESSAGE_EXE: [
		{
			"name" : "TotallyNotSpam.exe",
			"size" : 4,
			"anim_name": "exe"
		},
	]
}


# when a window spawns another window, offset is used to offset the newly instanced object
const window_properties = {
	WindowTypes.NORMAL: [
		{
			"title" : "System Message",
			"description" : "This is an error message. I am ERROR.",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "Unable to delete System32. Try contacting your local priest.",
			"offset" : 15
		},
	],
	WindowTypes.DOWNLOAD: [
		{
			"title" : "Limewire Pro - Free Version",
			"description" : "Your download is ready. Press button to start.",
			"offset" : 15
		},
	],
	WindowTypes.RECURSIVE: [
		{
			"title" : "Pintows XP",
			"description" : "Couldn't defragment the disk.",
			"offset" : 15
		},
	]
}
