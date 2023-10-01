extends CenterContainer


func set_icon(anim_name : String = ""):
	if anim_name == "":
		$SpriteDock/AnimatedSprite2D.hide()
	else:
		$SpriteDock/AnimatedSprite2D.show()
		$SpriteDock/AnimatedSprite2D.play(anim_name)
