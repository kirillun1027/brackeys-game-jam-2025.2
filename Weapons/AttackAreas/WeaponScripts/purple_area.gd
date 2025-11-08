extends AttackArea
class_name PurpleAttackArea

const SPEED: int = 200
var direction: Vector2
var enemy_group: StringName = "damagable"
@export var size_func: Curve
var lifetime: float = 1
var initial_size: float = 1
var time_elapsed: float = 0
var size_factor: float = 3.0
@onready var timer: Timer = $Timer

func setup(_lifetime: float, _initial_size: float):
	lifetime = _lifetime
	initial_size = _initial_size

func _ready() -> void:
	setup(source_weapon.lifetime, size_factor)
	scale = Vector2(initial_size, initial_size)
	timer.wait_time = lifetime
	timer.start()
	

func _physics_process(delta: float) -> void:
	time_elapsed = timer.wait_time - timer.time_left
	position += transform.x * SPEED / size_factor * delta
	var scale_multiplier: float = initial_size * size_func.sample(time_elapsed/lifetime)
	scale = Vector2(scale_multiplier, scale_multiplier)



func _on_body_entered(body: Node2D) -> void:
	attack(body, source_weapon.damage)
	if !body.is_in_group(enemy_group) and body is not StaticBody2D: return


func _on_timer_timeout() -> void:
	queue_free()
