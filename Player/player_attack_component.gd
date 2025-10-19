extends AttackComponent
class_name PlayerAttackComponent

@onready var weapon_sprite: Sprite2D = $"../WeaponSpriteContainer/WeaponSprite"
@onready var weapon_sprite_container: Node2D = $"../WeaponSpriteContainer"
@onready var animation_player: AnimationPlayer = $"../WeaponSpriteContainer/WeaponSprite/AnimationPlayer"

func _ready() -> void:
	cool_down_timer = $CooldownTimer
	add_weapon(Global.PURPLE)
	add_weapon(Global.HAMMER)
	swap_weapons()


func _process(delta: float) -> void:
	direction = (get_global_mouse_position() - global_position).normalized()
	weapon_sprite.rotation = _coords_to_angle(direction)


#region Weapon Swap and Input
func select_weapon(weapon_id: int):
	if available_weapons.size() <= weapon_id: return
	active_weapon = available_weapons[weapon_id]
	call_deferred("emit_signal", "weapons_updated", active_weapon)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("weapon_swap"):
		if !available_weapons.is_empty(): swap_weapons()
#endregion


func check_attack_instances_for(data: WeaponProperties) -> bool:
	if !attack_area_instances: return false
	for attack_area: AttackArea in attack_area_instances:
		if attack_area and attack_area.source_weapon.instanceof == data:
			return true
	return false


func _on_active_weapon_updated(weapon: Weapon) -> void:
	if !weapon: return
	weapon_sprite.texture = weapon.icon
