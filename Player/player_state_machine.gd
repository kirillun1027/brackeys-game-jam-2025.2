extends StateMachine
class_name PlayerStateMachine

const EPSILON: float = 0.1
var player: Player

func convert_8_to_4(vec: Vector2) -> Vector2:
	if vec == Vector2.DOWN or vec == Vector2.ZERO: return Vector2.DOWN
	if vec.x > EPSILON: return Vector2.RIGHT
	if vec.x < -EPSILON: return Vector2.LEFT
	return Vector2.UP

func _process(delta: float) -> void:
	player = get_parent()
	if player.velocity.length() <= EPSILON and active_state != states.get("idle"):
		change_state("idle")
		
	elif active_state != states.get("walk") and player.velocity.length() > EPSILON:
		change_state("walk")
