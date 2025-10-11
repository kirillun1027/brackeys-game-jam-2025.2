extends NavigationAgent2D
class_name NavigationComponent

@onready var player: Player = get_tree().current_scene.get_child(0).player
var enemy_positions: PackedVector2Array = []

func _ready() -> void:
	neighbor_distance = 0


func _physics_process(delta: float) -> void:
	if !player: return
	
	target_position = player.global_position
	var current_position = get_parent().global_position
	var next_path_position = get_next_path_position()
	velocity = current_position.direction_to(next_path_position)


func update_enemy_positions(positions: PackedVector2Array):
	enemy_positions = positions

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	get_parent().attack_direction = safe_velocity
	get_parent().retreat_direction = target_position.direction_to(get_parent().global_position)


#func _on_target_reached() -> void:
	#target_desired_distance = _range * 1.5
#
#
#func _on_path_changed() -> void:
	#target_desired_distance = _range
