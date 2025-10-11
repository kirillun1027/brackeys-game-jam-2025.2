class_name Enemy extends MobEntity

var attack_direction: Vector2 = Vector2.ZERO
var retreat_direction: Vector2 = Vector2.ZERO
var chase_distance: float = 500
var attack_distance: float = 60

func move(
	speed: float,
	direction: Vector2,
	_delta: float = 1.0/60.0, 
	acc_time: float = 0
	):
	velocity.x = move_toward(velocity.x, speed * direction.x, _delta * speed / acc_time)
	velocity.y = move_toward(velocity.y, speed * direction.y, _delta * speed / acc_time)

func _physics_process(delta: float) -> void:
	if velocity: 
		move_and_slide()
