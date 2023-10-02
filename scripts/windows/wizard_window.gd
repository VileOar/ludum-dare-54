extends DraggableWindow
class_name WizardWindow

@onready var back_button : Button = %BackButton
@onready var next_button : Button = %NextButton

const EXPLODE_QUANTITY = 3
var current_iteration := 0
const iterations_text = [
	{
		"description" : "Welcome to Pabaji Wizard.",
		"back_btn" : "< Back",
		"next_btn": "Next >"
	},
	{
		"description" : "Press Next after reading the license agreement",
		"back_btn" : "< Back",
		"next_btn": "Next >"
	},
	{
		"description" : "Setup will install Pabaji in the following folder: \nC\\:Cursed Files",
		"back_btn" : "< Back",
		"next_btn": "Next >"
	},
	{
		"description" : "Setup will not create a Start Menu folder",
		"back_btn" : "< Back",
		"next_btn": "Next >"
	},
	{
		"description" : "Setup is now ready to begin installing.",
		"back_btn" : "Cancel",
		"next_btn": "Install"
	},
]


func update_window_texts():
	back_button.text = iterations_text[current_iteration]["back_btn"]
	next_button.text = iterations_text[current_iteration]["next_btn"]
	window_text.text = iterations_text[current_iteration]["description"]


func _on_next_button_pressed():
	if current_iteration >= iterations_text.size()-1:
		SignalManager.explode_files.emit(position, EXPLODE_QUANTITY * Global.current_wave / 2.0)
		self.queue_free()
	else:

		current_iteration += 1
		update_window_texts()

		if current_iteration == 1:
			back_button.disabled = false

	
func _on_back_button_pressed():
	if current_iteration == iterations_text.size()-1:
		self.queue_free()	

	current_iteration -= 1
	current_iteration = clamp(current_iteration, 0, iterations_text.size()) # sanity check
	update_window_texts()

	if current_iteration <= 0:
		back_button.disabled = true
