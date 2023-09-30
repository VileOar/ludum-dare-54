extends Node

signal file_created(file)
signal release_file(file)

## emitted when someone wants to free space from disk (ex: empty trash, delete system32, ...)[br]
## should be caught by disk space manager
signal free_space(size)

# TODO: this signal might be here temporarily
# it would be cleaner to connect a signal directly from toolbar to recycle bin, but oh well
signal empty_trash
