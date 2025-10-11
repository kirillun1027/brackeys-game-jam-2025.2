extends State

var attack_speed: int = 50


func physics_update(delta: float) -> void:
	if entity is Enemy:
		entity.move(attack_speed, entity.attack_direction, delta)

func enter() -> void:
	var nav_component: NavigationComponent = get_parent().navigation_component
	nav_component.target_desired_distance /= 1.5
	nav_component.avoidance_enabled = true

func exit() -> void:
	var nav_component: NavigationComponent = get_parent().navigation_component
	nav_component.target_desired_distance *= 1.5
	nav_component.avoidance_enabled = true
