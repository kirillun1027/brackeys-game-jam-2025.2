extends AttackArea

var base_repulsion_strength: int = 100
@onready var lifetime_timer: Timer = $LifetimeTimer

func _ready() -> void:
	lifetime_timer.wait_time = source_weapon.lifetime

func _on_body_entered(body: Node2D) -> void:
	var repulsion_strength: float = 1 / body.global_position.distance_to(global_position) * base_repulsion_strength
	if body.is_in_group(source_entity.DAMAGE_GROUP):
		body.velocity += global_position.direction_to(body.global_position) * repulsion_strength
		attack(body, source_weapon.damage)


func _on_lifetime_timeout() -> void:
	queue_free()
