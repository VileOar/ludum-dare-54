extends AnimatedSprite2D
class_name BoomAnim


func _ready():
	play("default")


func _on_anim_end():
	queue_free()
