extends AttackArea
class_name RedAttackArea

var base_repulsion_strength: int = 800
const EULERS_CONSTANT: float = 2.7
const RANGE_EXP_CONST: float = 1.0 / 64.0
var affected_bodies: Array[Node2D] = []
@onready var lifetime_timer: Timer = $LifetimeTimer
@onready var loop_animator: AnimationPlayer = $Icon/LoopAnimator
@onready var single_use_animator: AnimationPlayer = $Icon/SingleUseAnimator
@onready var explosion_timer: Timer = $ExplosionTimer


func _ready() -> void:
	loop_animator.play("red_rotating")
	single_use_animator.play("red_scaling")
	lifetime_timer.wait_time = source_weapon.lifetime
	var animation_base_time: float = loop_animator.current_animation_length
	loop_animator.speed_scale = animation_base_time / lifetime_timer.wait_time
	single_use_animator.speed_scale = animation_base_time / explosion_timer.wait_time / 2

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.velocity = Vector2.ZERO
		affected_bodies.append(body)


func _on_lifetime_timeout() -> void:
	queue_free()


func _on_explosion_timeout() -> void:
	for body in affected_bodies:
		if body is not Enemy: return
		var distance_to_target: float = body.global_position.distance_to(global_position)
		var repulsion_strength: float = base_repulsion_strength * pow(EULERS_CONSTANT, -1.0 * RANGE_EXP_CONST * distance_to_target)
		var impulse: Vector2 = global_position.direction_to(body.global_position) * repulsion_strength
		body.velocity += impulse / body.mass if body is Enemy else impulse
		attack(body, roundi(source_weapon.damage * pow(EULERS_CONSTANT,-1.0 * RANGE_EXP_CONST * distance_to_target)))
