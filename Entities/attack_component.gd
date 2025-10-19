extends Node2D
class_name AttackComponent

var cool_down_timer: Timer
@onready var world: Node2D = get_tree().current_scene.get_child(0)

var attack_area_instances: Array[Node]
var direction: Vector2 = Vector2.ZERO
var is_cooldown: bool = false
var is_infinity_on: bool = false
signal weapons_updated(weapon: Weapon)

##region Weapon Property Preload
#const BOW: WeaponProperties = preload("uid://ca40vurd7co11")
#const SWORD: WeaponProperties = preload("uid://b7q55dylcodhw")
#const HAMMER: WeaponProperties = preload("uid://b0vbx0xus6sb3")
#const INFINITY: WeaponProperties = preload("uid://dbxtv4hoosdti")
#const PURPLE: WeaponProperties = preload("uid://b1fx0qksj15pc")
##endregion
#region Weapon Property Preload
var bow: WeaponProperties
var sword: WeaponProperties
var hammer: WeaponProperties
var infinity: WeaponProperties
var purple: WeaponProperties
#endregion

var available_weapons: Array[Weapon] = [
	
]

var active_weapon: Weapon

var AttackTypes = WeaponProperties.AttackTypes

var WeaponBaseStats: Dictionary[Weapon, WeaponProperties] = {}

#func nullpoint() -> void:
	#bow = Global.BOW
	#sword = Global.SWORD
	#hammer = Global.HAMMER
	#infinity = Global.INFINITY
	#purple = Global.PURPLE

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
	
	if active_weapon.instanceof == Global.PURPLE:
		attack_area.lifetime = active_weapon.lifetime
	
	if active_weapon.instanceof == Global.INFINITY:
		update_infinity_effect(true)

func add_weapon(properties: WeaponProperties):
	var new_weapon = Weapon.new(properties)
	available_weapons.append(new_weapon)
	WeaponBaseStats.get_or_add(new_weapon, properties)
	weapons_updated.emit(active_weapon)

func _coords_to_angle(coords: Vector2) -> float:
	var angle: float = 0
	var x: float = coords.x; var y: float = coords.y
	if x >= 0: angle = asin(y)
	if x < 0:
		if y >= 0: angle = acos(x)
		else: angle = -acos(x)
	return angle



func update_infinity_effect(_toggle: bool = is_infinity_on):
	is_infinity_on = _toggle
	get_parent().is_physical_damage_immune = is_infinity_on

func _on_cooldown_timeout() -> void:
	is_cooldown = false
	cool_down_timer.stop()
