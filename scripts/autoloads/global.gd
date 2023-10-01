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
	RECYCLING, ## temporary window while trash is being emptied
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
		print("Changed wave to ")
		print(value)
		current_wave = value
		if current_wave > WAVE_TIMES.size():
			current_wave = WAVE_TIMES.size()

## Weights of spawn dictated by current wave
const FILE_TYPES_WEIGHTS = [
	{
		FileTypes.NORMAL : 5,
		FileTypes.INCREASE_SPAWN_EXE : 0,
		FileTypes.CORRUPTED_FOLDER : 0,
		FileTypes.ERROR_MESSAGE_EXE : 5
	},
	{
		FileTypes.NORMAL : 7,
		FileTypes.INCREASE_SPAWN_EXE : 2,
		FileTypes.CORRUPTED_FOLDER : 1,
		FileTypes.ERROR_MESSAGE_EXE : 0
	},
	{
		FileTypes.NORMAL : 15,
		FileTypes.INCREASE_SPAWN_EXE : 2,
		FileTypes.CORRUPTED_FOLDER : 1,
		FileTypes.ERROR_MESSAGE_EXE : 2
	},
	{
		FileTypes.NORMAL : 15,
		FileTypes.INCREASE_SPAWN_EXE : 3,
		FileTypes.CORRUPTED_FOLDER : 3,
		FileTypes.ERROR_MESSAGE_EXE : 3
	},
	{
		FileTypes.NORMAL : 20,
		FileTypes.INCREASE_SPAWN_EXE : 5,
		FileTypes.CORRUPTED_FOLDER : 5,
		FileTypes.ERROR_MESSAGE_EXE : 5
	}
]

## should only be set by desktop
var bounds_rect : Rect2

const EXPLODE_SPEED = 480.0
const CORRUPTED_COLOUR = Color(1, 0.9, 0.9, 1)

## max disk space (could be altered by powerups)
const MAX_DISK_SPACE = 1024
## not actually a limit for the trash bin itself but for its delay
const MAX_TRASH_SPACE = 256

## this assumes that we want the recycle window to always spawn in the same place
const RECYCLE_WINDOW_POS := Vector2(256, 256)

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
		{
			"name" : "underleaf.html",
			"size" : 22,
			"anim_name": "link"
		},
		{
			"name" : "myself.png",
			"size" : 24,
			"anim_name": "png"
		},
		{
			"name" : "Family.jpg",
			"size" : 100,
			"anim_name": "png"
		},
		{
			"name" : "Mr. Wild",
			"size" : 10,
			"anim_name": "link"
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
			"name" : "high-tier-god.exe",
			"size" : 20,
			"anim_name": "exe"
		},
		{
			"name" : "mytube.exe",
			"size" : 10,
			"anim_name": "exe"
		},
	],
	FileTypes.CORRUPTED_FOLDER: [
		{
			"name" : "justfans",
			"size" : 24,
			"anim_name": "folder"
		},
		{
			"name" : "leaked tests",
			"size" : 18,
			"anim_name": "folder"
		},
		{
			"name" : "lmao",
			"size" : 18,
			"anim_name": "folder"
		},
	],
	FileTypes.ERROR_MESSAGE_EXE: [
		{
			"name" : "TotallyNotSpam",
			"size" : 4,
			"anim_name": "link"
		},
		{
			"name" : "README",
			"size" : 20,
			"anim_name": "link"
		},
		{
			"name" : "SUSBSCRIBE tO My CAHNHEL",
			"size" : 24,
			"anim_name": "link"
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
			"title" : "Error",
			"description" : "You are an error.",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "Unable to delete System32. Try contacting your local priest.",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "L + cringe + ratio + didn't ask + skill issue",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "You shouldn't have tried those free V-Bucks buddy",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "You should surrender yoursef, NOW!",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "Have you tried, i don't know, git gud?",
			"offset" : 15
		},
		{
			"title" : "Masterchef Official",
			"description" : "What is bro cooking?",
			"offset" : 15
		},
		{
			"title" : ">:]",
			"description" : ">:]",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "Oops, I hope this message doesn't disturb your desktop at all :)",
			"offset" : 15
		},
		{
			"title" : "Don't be poor",
			"description" : "Just pay my bitcoins and the PC is all yours again.",
			"offset" : 15
		},
		{
			"title" : "System Message",
			"description" : "You cannot escape this, I control everything buddy.",
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
	],
	WindowTypes.RECYCLING: [
		{
			"title" : "Trash Bin",
			"description" : "Recycling...",
			"offset" : 15
		},
	]
}

