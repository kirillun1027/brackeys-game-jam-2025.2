extends Node2D
class_name PlayerAttackComponent

@onready var lifetime_timer: Timer = $LifetimeTimer
@onready var cool_down_timer: Timer = $CooldownTimer
@onready var world: Node2D = get_tree().current_scene.get_child(0)
@onready var weapon_sprite: Sprite2D = $"../WeaponSpriteContainer/WeaponSprite"
@onready var weapon_sprite_container: Node2D = $"../WeaponSpriteContainer"
@onready var animation_player: AnimationPlayer = $"../WeaponSpriteContainer/WeaponSprite/AnimationPlayer"


var attack_area_instances: Array[Node]
var direction: Vector2 = Vector2.ZERO
var is_cooldown: bool = false
signal weapons_updated(weapon: Weapon)

#region Weapon Property Preload
const BOW: WeaponProperties = preload("res://Weapons/WeaponData/bow.tres")
const SWORD: WeaponProperties = preload("res://Weapons/WeaponData/sword.tres")
const HAMMER: WeaponProperties = preload("res://Weapons/WeaponData/hammer.tres")
#endregion

var available_weapons: Array[Weapon] = [
	
]

var active_weapon: Weapon

var AttackTypes = WeaponProperties.AttackTypes

var WeaponBaseStats: Dictionary[Weapon, WeaponProperties] = {}

func _ready() -> void:
	add_weapon(HAMMER)
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

func swap_weapons():
	if available_weapons.is_empty(): return
	var current_weapon_id = available_weapons.find(active_weapon)
	if current_weapon_id < available_weapons.size() - 1:
		active_weapon = available_weapons[current_weapon_id + 1]
	else:
		active_weapon = available_weapons[0]
	call_deferred("emit_signal", "weapons_updated", active_weapon)


func select_weapon(weapon_id: int):
	if available_weapons.size() <= weapon_id: return
	active_weapon = available_weapons[weapon_id]
	call_deferred("emit_signal", "weapons_updated", active_weapon)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("weapon_swap"):
		if !available_weapons.is_empty(): swap_weapons()
#endregion


#region Attack Management

func attack():
	if !active_weapon: return
	if is_cooldown: return
	set_rotation(_coords_to_angle(direction)) # Handle attack area transform
	
	# Handle Timers
	lifetime_timer.wait_time = active_weapon.lifetime
	cool_down_timer.wait_time = active_weapon.cooldown
	lifetime_timer.start()
	cool_down_timer.start()
	is_cooldown = true
	
	var attack_area = active_weapon.attack_area.instantiate() # Spawn attack area
	attack_area_instances.append(attack_area) # Register attack area
	play_animation()
	
	# Set attack area properties
	if active_weapon.attack_type == AttackTypes.RANGED:
		attack_area.global_transform = global_transform
		world.EntityPool.call_deferred("add_child", attack_area)
	else:
		call_deferred("add_child", attack_area)
	
	attack_area.body_entered.connect(on_body_attacked)


func on_body_attacked(body: Node):
	if body.is_in_group("damagable"): 
		body.recieve_damage(active_weapon.damage)
		if body is Enemy:
			if body.died.is_connected(on_enemy_death): return
			body.died.connect(on_enemy_death)
		return
	if body is Player and body.name != get_parent().name: 
		body.recieve_damage(active_weapon.damage)
		return
#endregion


func on_enemy_death():
	get_parent().biscuits += 1

#region Timers

func _on_lifetime_timeout() -> void:
	if attack_area_instances and active_weapon.attack_type == AttackTypes.RANGED:
		if attack_area_instances.front():
			attack_area_instances.pop_front().queue_free()

func _on_cooldown_timeout() -> void:
	is_cooldown = false
	cool_down_timer.stop()

#endregion

func _on_active_weapon_updated(weapon: Weapon) -> void:
	if !weapon: return
	weapon_sprite.texture = weapon.icon

func _coords_to_angle(coords: Vector2) -> float:
	var angle: float = 0
	var x: float = coords.x; var y: float = coords.y
	if x >= 0: angle = asin(y)
	if x < 0:
		if y >= 0: angle = acos(x)
		else: angle = -acos(x)
	return angle

func play_animation():
	if active_weapon.instance_of == "sword":
		animation_player.play("sword_swing")
