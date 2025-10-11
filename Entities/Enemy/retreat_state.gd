extends State

var retreat_speed: int = 70

func enter() -> void:
	var nav_component: NavigationComponent = get_parent().navigation_component
	nav_component.target_desired_distance *= 1.5
	nav_component.avoidance_enabled = true

func physics_update(delta: float) -> void:
	if entity is Enemy:
		entity.move(retreat_speed, entity.retreat_direction, delta)

func exit() -> void:
	var nav_component: NavigationComponent = get_parent().navigation_component
	nav_component.target_desired_distance /= 1.5
	nav_component.avoidance_enabled = false
	
