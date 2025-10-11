extends AnimatedSprite2D


func _on_play(anim_name: StringName, fliph: bool) -> void:
	flip_h = fliph
	play(anim_name)
