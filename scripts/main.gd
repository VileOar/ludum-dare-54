extends Node2D

@onready var animation = $AnimationPlayer


func _ready():
	SignalManager.disk_full.connect(_on_disk_full)

	animation.play("enter")
	Global.reset_on_play()


func _on_game_timer_timeout():
	Global.game_time += 1


func _on_disk_full():
	Global.handle_highscore()