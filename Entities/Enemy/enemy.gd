class_name Enemy extends MobEntity

var attack_direction: Vector2 = Vector2.ZERO
var retreat_direction: Vector2 = Vector2.ZERO
var chase_distance: float = 500
var attack_distance: float = 60
var acceleration_time: float = .25
var base_speed: int = 100
var mass: float = 1

func move(
	speed: float,
	direction: Vector2,
	_delta: float = 1.0/60.0, 
	acc_time: float = acceleration_time
	):
	velocity.x = move_toward(velocity.x, speed * direction.x, _delta * base_speed / acc_time)
	velocity.y = move_toward(velocity.y, speed * direction.y, _delta * base_speed / acc_time)

func _physics_process(delta: float) -> void:
	if velocity: 
		move_and_slide()
