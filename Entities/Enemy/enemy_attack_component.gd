extends AttackComponent
class_name EnemyAttackComponent

@onready var state_machine: EnemyStateMachine = $"../EnemyStateMachine"

func _ready() -> void:
	cool_down_timer = $CooldownTimer
	call_deferred("initialize")
	add_weapon(SWORD)
	swap_weapons()

func add_weapon(properties: WeaponProperties):
	var new_weapon = Weapon.new(properties)
	available_weapons.append(new_weapon)
	WeaponBaseStats.get_or_add(new_weapon, properties)
	weapons_updated.emit(active_weapon)

func initialize():
	if !state_machine.navigation_component: push_error("null nav"); return
	match active_weapon.attack_type:
		AttackTypes.RANGED:
			state_machine.navigation_component.target_desired_distance = 100
		AttackTypes.MELEE:
			state_machine.navigation_component.target_desired_distance = 30

func _process(delta: float) -> void:
	direction = (world.player.global_position - global_position).normalized()
	if (state_machine.active_state == state_machine.states.get("attack")\
	 or state_machine.active_state == state_machine.states.get("retreat"))\
	 and get_parent().is_alive:
		attack()


#func attack():
	#if is_cooldown: return
	## Handle attack area transform
	#set_rotation(_coords_to_angle(direction))
	## Handle Timers
	#lifetime_timer.wait_time = active_weapon.lifetime
	#cool_down_timer.wait_time = active_weapon.cooldown
	#lifetime_timer.start()
	#cool_down_timer.start()
	#is_cooldown = true
	## Spawn attack area
	#var attack_area = active_weapon.attack_area.instantiate()
	#attack_area_instances.append(attack_area)
		#
	## Set attack area properties
	#if active_weapon.attack_type == AttackTypes.RANGED:
		#attack_area.enemy_group = "player"
		#attack_area.global_transform = global_transform
		#world.EntityPool.call_deferred("add_child", attack_area)
	#else:
		#call_deferred("add_child", attack_area)
	##attack_area.get_node("Polygon2D").set_polygon(attack_area.get_node("AttackPolygon").get_polygon())
	#attack_area.body_entered.connect(on_body_attacked)


#func _on_lifetime_timeout() -> void:
	#if attack_area_instances and active_weapon.attack_type == AttackTypes.RANGED:
		#if attack_area_instances.front():
			#attack_area_instances.pop_front().queue_free()
#
#
#func _on_cooldown_timeout() -> void:
	#is_cooldown = false
	#cool_down_timer.stop()
