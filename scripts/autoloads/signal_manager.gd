extends Node

signal toggle_antivirus

signal release_files(files)

## emitted when someone wants to free space from disk (ex: empty trash, delete system32, ...)[br]
## should be caught by disk space manager
signal free_space(size)

# TODO: this signal might be here temporarily
# it would be cleaner to connect a signal directly from toolbar to recycle bin, but oh well
signal empty_trash

## used to increase disk space for example
signal file_created(file)

# Corrupted Files signals
signal change_spawn_time(time, duration)
signal explode_files(origin_point, quantity)


# Spawning stuffs

## desktop is responsible for actually creating a window
signal new_window(window_type, last_position)

## this signal is emitted periodically with a file type by the file spawner[br]
## the desktop should be in charge of actually creating the file node and randomly populating it
signal new_file(file_type)
