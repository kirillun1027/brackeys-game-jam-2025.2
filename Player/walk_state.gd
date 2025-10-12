extends State
class_name Walk

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
var player: Player


func enter() -> void:
	player = get_parent().get_parent()
	direction = state_machine.convert_8_to_4(player.public_direction)
	if dir_data.get(direction) != "left":
		play.emit("walk_" + dir_data.get(direction), false)
	else: play.emit("walk_right", true)

func physics_update(delta: float) -> void:
	if state_machine.convert_8_to_4(player.public_direction) != direction:
		direction = state_machine.convert_8_to_4(player.public_direction)
		if dir_data.get(direction) != "left":
			play.emit("walk_" + dir_data.get(direction), false)
		else: 
			play.emit("walk_right", true)
