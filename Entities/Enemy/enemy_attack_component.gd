extends AttackComponent
class_name EnemyAttackComponent

@onready var state_machine: EnemyStateMachine = $"../EnemyStateMachine"

func _ready() -> void:
	cool_down_timer = $CooldownTimer
	call_deferred("initialize")
	add_weapon(Global.SWORD)
	swap_weapons()

func initialize():
	if !state_machine.navigation_component: push_error("null nav"); return
	if !active_weapon: return
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
