extends Node2D
class_name AttackComponent

var cool_down_timer: Timer
@onready var world: Node2D = get_tree().current_scene.get_child(0)

var attack_area_instances: Array[Node]
var direction: Vector2 = Vector2.ZERO
var is_cooldown: bool = false
var is_infinity_on: bool = false
signal weapons_updated(weapon: Weapon)

#region Weapon Property Preload
const BOW: WeaponProperties = preload("res://Weapons/WeaponData/bow.tres")
const SWORD: WeaponProperties = preload("res://Weapons/WeaponData/sword.tres")
const HAMMER: WeaponProperties = preload("res://Weapons/WeaponData/hammer.tres")
const INFINITY: WeaponProperties = preload("res://Weapons/WeaponData/infinity.tres")
const PURPLE: WeaponProperties = preload("res://Weapons/WeaponData/purple.tres")
#endregion

var available_weapons: Array[Weapon] = [
	
]

var active_weapon: Weapon

var AttackTypes = WeaponProperties.AttackTypes

var WeaponBaseStats: Dictionary[Weapon, WeaponProperties] = {}

func swap_weapons():
	if available_weapons.is_empty(): return
	var current_weapon_id = available_weapons.find(active_weapon)
	if current_weapon_id < available_weapons.size() - 1:
		active_weapon = available_weapons[current_weapon_id + 1]
	else:
		active_weapon = available_weapons[0]
	call_deferred("emit_signal", "weapons_updated", active_weapon)

func attack():
	if !active_weapon: return
	if is_cooldown: return
	
	set_rotation(_coords_to_angle(direction)) # Handle attack area transform
	
	# Handle Timers
	cool_down_timer.wait_time = active_weapon.cooldown
	cool_down_timer.start()
	is_cooldown = true
	
	var attack_area: AttackArea = active_weapon.attack_area.instantiate() # Spawn attack area
	attack_area_instances.append(attack_area) # Register attack area
	#play_animation()
	
	# Set attack area properties
	if active_weapon.attack_type == AttackTypes.RANGED:
		attack_area.global_transform = global_transform
		world.EntityPool.call_deferred("add_child", attack_area)
	else:
		call_deferred("add_child", attack_area)
	
	attack_area.source_weapon = active_weapon
	attack_area.source_entity = get_parent()
	
	var on_enemy_death = func ():
		if not (get_parent() is Player): return
		get_parent().biscuits += 1
	
	attack_area.enemy_died.connect(on_enemy_death)
	
	if active_weapon.instanceof == PURPLE:
		attack_area.lifetime = active_weapon.lifetime
	
	if active_weapon.instanceof == INFINITY:
		update_infinity_effect(true)

func _coords_to_angle(coords: Vector2) -> float:
	var angle: float = 0
	var x: float = coords.x; var y: float = coords.y
	if x >= 0: angle = asin(y)
	if x < 0:
		if y >= 0: angle = acos(x)
		else: angle = -acos(x)
	return angle

#func play_animation():
	#if active_weapon.instanceof == SWORD:
		#animation_player.play("sword_swing")


func update_infinity_effect(_toggle: bool = is_infinity_on):
	is_infinity_on = _toggle
	get_parent().is_physical_damage_immune = is_infinity_on

func _on_cooldown_timeout() -> void:
	is_cooldown = false
	cool_down_timer.stop()
