extends AttackArea
class_name SwordAttackArea

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("attack")
	await animated_sprite_2d.animation_finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	attack(body, source_weapon.damage)
