class_name HowToPlay
extends MarginContainer
## Screen for controlling the how to play interactions

@onready var _tab_buttons = %TabButtons

@onready var _screen_container = %ScreenContainer
@onready var _objectives = %Objectives
@onready var _corrupted = %Corrupted
@onready var _antivirus = %Antivirus


var _tab_btn_group: ButtonGroup


# Called when the node enters the scene tree for the first time.
func _ready():
	_tab_btn_group = ButtonGroup.new()
	_tab_btn_group.allow_unpress = false
	for btn in _tab_buttons.get_children():
		btn = btn as Button
		btn.button_group = _tab_btn_group
	var _v = _tab_btn_group.pressed.connect(_on_tab_changed)
	_objectives.show()

func _on_tab_changed(button: BaseButton):
	for node in _screen_container.get_children():
		node.hide()
	match button.name:
		"BtnObjectives":
			_objectives.show()
		"BtnCorrupted":
			_corrupted.show()
		"BtnAntivirus":
			_antivirus.show()
