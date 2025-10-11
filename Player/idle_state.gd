extends State
class_name Idle

var direction: Vector2 = Vector2.ZERO
var dir_data: Dictionary = {
	Vector2.ZERO: "down",
	Vector2.DOWN: "down",
	Vector2.UP: "up",
	Vector2.RIGHT: "right",
	Vector2.LEFT: "left",
}
var dir_name: StringName
signal play(anim_name: StringName, fliph: bool)
var is_flipped


func enter() -> void:
	state_machine = state_machine as PlayerStateMachine
	direction = state_machine.convert_8_to_4(get_parent().get_parent().public_direction)
	if dir_data.get(direction) != "left":	
		play.emit("idle_" + dir_data.get(direction), false)
	else: play.emit("idle_right", true)
