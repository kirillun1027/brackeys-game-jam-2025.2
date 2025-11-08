extends ProgressBar

var mouse_offset: Vector2 = Vector2(32,-64)
@onready var world: Node2D = get_tree().current_scene.get_child(0)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + mouse_offset
	if value == 1: hide()
	else: show()
