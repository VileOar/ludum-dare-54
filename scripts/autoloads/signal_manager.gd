extends Node


signal toggle_antivirus

## called when mouse stops holding files
signal release_files(files)

## used to increase disk space for example
signal file_created(file)


# --- || AUDIO || ---

signal disk_almost_full

# --- || RECYCLING || ---

# TODO: it would be cleaner to connect a signal directly from toolbar to recycle bin, but oh well
## emitted by the empty trash button and caught by the trash bin
signal empty_trash

## emitted when someone wants to free space from disk (ex: empty trash, delete system32, ...)[br]
## should be caught by disk space manager
signal free_space(size)

signal after_recycle_time


# --- || CORRUPTED FILE BEHAVIOUR || ---

signal change_spawn_time(time, duration)

signal explode_files(origin_point, quantity)


# --- || SPAWN OBJECTS || ---

## desktop is responsible for actually creating a window
signal new_window(window_type, last_position)

## this signal is emitted periodically with a file type by the file spawner[br]
## the desktop should be in charge of actually creating the file node and randomly populating it
signal new_file(file_type)
