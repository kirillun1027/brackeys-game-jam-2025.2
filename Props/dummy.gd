class_name MobEntity extends CharacterBody2D

@export var hp: int = 5
@onready var animation_timer: Timer = $AnimationTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var original_modulate = sprite_2d.modulate
@onready var damage_label: Label = $DamageLabel
signal died
var is_alive: bool = true
const DAMAGE_GROUP: StringName = "enemy"

func recieve_damage(dmg: int) -> void:
	hp -= dmg
	animation_timer.start()
	sprite_2d.modulate = Color("RED")
	damage_label.text = str(dmg)
	damage_label.show()
	if hp <= 0:
		die()
		return




func _on_animation_timeout() -> void:
	sprite_2d.modulate = original_modulate
	damage_label.text = ""
	damage_label.hide()

func die():
	call_deferred("emit_signal", "died")
	is_alive = false
	velocity = Vector2.ZERO
	set_process(false)
	await animation_timer.timeout
	queue_free()
