extends Node2D

var lifted := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if lifted:
		position = get_global_mouse_position()


func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if event.pressed:
					lifted = true
				else:
					lifted = false
			# RIGHT CLICK HANDLER GOES HERE
