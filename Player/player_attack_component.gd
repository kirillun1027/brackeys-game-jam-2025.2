extends AttackComponent
class_name PlayerAttackComponent

@onready var weapon_sprite: Sprite2D = $"../WeaponSpriteContainer/WeaponSprite"
@onready var weapon_sprite_container: Node2D = $"../WeaponSpriteContainer"
@onready var animation_player: AnimationPlayer = $"../WeaponSpriteContainer/WeaponSprite/AnimationPlayer"
#@onready var lifetime_timer: Timer = $LifetimeTimer
#@onready var cool_down_timer: Timer = $CooldownTimer
#@onready var world: Node2D = get_tree().current_scene.get_child(0)
#@onready var weapon_sprite: Sprite2D = $"../WeaponSpriteContainer/WeaponSprite"
#@onready var weapon_sprite_container: Node2D = $"../WeaponSpriteContainer"
#@onready var animation_player: AnimationPlayer = $"../WeaponSpriteContainer/WeaponSprite/AnimationPlayer"
#
#
#var attack_area_instances: Array[Node]
#var direction: Vector2 = Vector2.ZERO
#var is_cooldown: bool = false
#var is_infinity_on: bool = false
#signal weapons_updated(weapon: Weapon)
#
##region Weapon Property Preload
#const BOW: WeaponProperties = preload("res://Weapons/WeaponData/bow.tres")
#const SWORD: WeaponProperties = preload("res://Weapons/WeaponData/sword.tres")
#const HAMMER: WeaponProperties = preload("res://Weapons/WeaponData/hammer.tres")
#const INFINITY: WeaponProperties = preload("res://Weapons/WeaponData/infinity.tres")
#const PURPLE: WeaponProperties = preload("res://Weapons/WeaponData/purple.tres")
##endregion
#
#var available_weapons: Array[Weapon] = [
	#
#]
#
#var active_weapon: Weapon
#
#var AttackTypes = WeaponProperties.AttackTypes
#
#var WeaponBaseStats: Dictionary[Weapon, WeaponProperties] = {}

func _ready() -> void:
	cool_down_timer = $CooldownTimer
	add_weapon(PURPLE)
	add_weapon(HAMMER)
	swap_weapons()

func add_weapon(properties: WeaponProperties):
	var new_weapon = Weapon.new(properties)
	available_weapons.append(new_weapon)
	WeaponBaseStats.get_or_add(new_weapon, properties)
	weapons_updated.emit(active_weapon)

func _process(delta: float) -> void:
	direction = (get_global_mouse_position() - global_position).normalized()
	weapon_sprite.rotation = _coords_to_angle(direction)


#region Weapon Swap and Input
#
#func swap_weapons():
	#if available_weapons.is_empty(): return
	#var current_weapon_id = available_weapons.find(active_weapon)
	#if current_weapon_id < available_weapons.size() - 1:
		#active_weapon = available_weapons[current_weapon_id + 1]
	#else:
		#active_weapon = available_weapons[0]
	#call_deferred("emit_signal", "weapons_updated", active_weapon)


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
#region Timers

#func _on_lifetime_timeout() -> void:
	#if attack_area_instances and active_weapon.attack_type == AttackTypes.RANGED:
		#if attack_area_instances.front():
			#attack_area_instances.pop_front().queue_free()
	#if check_attack_instances_for(INFINITY):	update_infinity_effect(false)



#endregion

func _on_active_weapon_updated(weapon: Weapon) -> void:
	if !weapon: return
	weapon_sprite.texture = weapon.icon
