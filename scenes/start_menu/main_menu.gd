extends Control


@export var main_scene : PackedScene

@onready var _menu_audio = $MenuAudio
@onready var _animation_player = %AnimationPlayer

@onready var _main_buttons = %Buttons
@onready var _backable_screens = %BackableScreens

@onready var _screen_holder = %ScreenHolder
@onready var _credits = %Credits
@onready var _how_to_play = %HowToPlay


func _ready():
	for btn in find_children("*", "BaseButton"):
		(btn as BaseButton).mouse_entered.connect(_on_btn_mouse_entered)


func _on_btn_mouse_entered():
	_menu_audio.play_hover_sfx()


func _on_back_pressed():
	_backable_screens.hide()
	_main_buttons.show()


func _on_start_pressed():
	_animation_player.play("start")
	await _animation_player.animation_finished
	get_tree().change_scene_to_packed(main_scene)


func _on_how_to_play_pressed():
	_main_buttons.hide()
	_backable_screens.show()
	for node in _screen_holder.get_children():
		node.hide()
	_how_to_play.show()


func _on_credits_pressed():
	_main_buttons.hide()
	_backable_screens.show()
	for node in _screen_holder.get_children():
		node.hide()
	_credits.show()


func _on_exit_pressed():
	get_tree().quit()
