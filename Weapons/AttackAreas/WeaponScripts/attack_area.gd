extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const area_instanceof = "sword"

func _ready() -> void:
	animated_sprite_2d.play("attack")
	await animated_sprite_2d.animation_finished
	queue_free()
