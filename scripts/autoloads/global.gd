extends Node

var selected_files : Array = []
var ignore_inputs := false


func _ready():
	randomize()


func reset_on_play():
	game_time = 0
	current_wave = 1


enum FileTypes {
	NORMAL, ## a simple file with no gimmicks
	INCREASE_SPAWN_EXE, ## increase the spawn rate considerably
	CORRUPTED_FOLDER, ## "explodes" in several files when deleted
	ERROR_MESSAGE_EXE, ## infintely spawns error messages
	DOWNLOAD_EXE, ## show download bar (TODO: that can be easily closed...?)
	RECURSIVE,
#	ADD_POPUP_EXE, ## spawns an add popup
	# TODO: add more as needed
}

enum WindowTypes {
	NORMAL, ## a simple window with no gimmicks
	DOWNLOAD, ## can be simply closed or used to download more files
	RECURSIVE, ## spawns a message of the same type if wrong choiced is picked
	RECYCLING, ## temporary window while trash is being emptied
}


# --- || GAME TIME || ---

var game_time := 0
var best_time := 0

func time_to_str(time:int) -> String:
	var seconds = time % 60
	var minutes = int(time / float(60))
	var minutes_str = str(minutes)
	var seconds_str = str(seconds)
	if minutes < 10:
		minutes_str = "0" + minutes_str
	if seconds < 10:
		seconds_str = "0" + seconds_str
	
	return minutes_str + ":" + seconds_str


func handle_highscore():
	if game_time > best_time:
		best_time = game_time


# --- || WAVES || ---

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
		FileTypes.CORRUPTED_FOLDER : 1,
		FileTypes.ERROR_MESSAGE_EXE : 1,
		FileTypes.DOWNLOAD_EXE: 0,
		FileTypes.RECURSIVE: 0,
	},
	{
		FileTypes.NORMAL : 7,
		FileTypes.INCREASE_SPAWN_EXE : 1,
		FileTypes.CORRUPTED_FOLDER : 1,
		FileTypes.ERROR_MESSAGE_EXE : 1,
		FileTypes.DOWNLOAD_EXE: 0,
		FileTypes.RECURSIVE: 1,
	},
	{
		FileTypes.NORMAL : 10,
		FileTypes.INCREASE_SPAWN_EXE : 2,
		FileTypes.CORRUPTED_FOLDER : 2,
		FileTypes.ERROR_MESSAGE_EXE : 1,
		FileTypes.DOWNLOAD_EXE: 1,
		FileTypes.RECURSIVE: 1,
	},
	{
		FileTypes.NORMAL : 20,
		FileTypes.INCREASE_SPAWN_EXE : 3,
		FileTypes.CORRUPTED_FOLDER : 3,
		FileTypes.ERROR_MESSAGE_EXE : 3,
		FileTypes.DOWNLOAD_EXE: 1,
		FileTypes.RECURSIVE: 1,
	},
	{
		FileTypes.NORMAL : 30,
		FileTypes.INCREASE_SPAWN_EXE : 5,
		FileTypes.CORRUPTED_FOLDER : 5,
		FileTypes.ERROR_MESSAGE_EXE : 5,
		FileTypes.DOWNLOAD_EXE: 3,
		FileTypes.RECURSIVE: 3,
	}
]


# --- || OTHER || ---

## should only be set by desktop
var bounds_rect : Rect2

const EXPLODE_SPEED = 480.0
const CORRUPTED_COLOUR = Color(1, 0.9, 0.9, 1)

## max disk space (could be altered by powerups)
const MAX_DISK_SPACE = 1024
## not actually a limit for the trash bin itself but for its delay
const MAX_TRASH_SPACE = 512

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
			"anim_name": "badlink"
		},
		{
			"name" : "README",
			"size" : 20,
			"anim_name": "badlink"
		},
		{
			"name" : "SUSBSCRIBE tO My CAHNHEL",
			"size" : 24,
			"anim_name": "badlink"
		},
	],
	FileTypes.DOWNLOAD_EXE: [
		{
			"name" : "Roblux",
			"size" : 4,
			"anim_name": "download"
		},
	],
	FileTypes.RECURSIVE: [
		{
			"name" : "no_u.gmm",
			"size" : 4,
			"anim_name": "code"
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

