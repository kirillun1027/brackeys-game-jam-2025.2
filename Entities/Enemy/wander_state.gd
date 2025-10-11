extends State

var current_direction: Vector2 = Vector2.ZERO
var wander_speed: int = 50

func enter() -> void:
	generate_new_direction()
	get_parent().navigation_component.avoidance_enabled = false

func physics_update(delta: float) -> void:
	if entity is Enemy:
		entity.move(wander_speed, current_direction, delta)

func generate_new_direction() -> void:
	randomize()
	if randi_range(0,1) == 1: 
		current_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	else: current_direction = Vector2.ZERO

func _on_timeout() -> void:
	generate_new_direction()
