extends AttackArea
class_name BowAttackArea

const SPEED: int = 500
var direction: Vector2

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(source_entity.DAMAGE_GROUP) and body is not StaticBody2D: return
	attack(body, source_weapon.damage)
	queue_free()
