extends CharacterBody2D 
class_name Player

@export var dash_graph: Curve
@export var health: float = 10
@export var attack_area_rotation: float = 0
@export var spawn_points: Node2D
@export var speed: float = 120
var acc_time: float = .125
var sprint_speed: float = speed * 1.5
var dash_speed: float = speed * 4
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var player_id: int = 1
var biscuits: int = 10
var is_in_safe_zone: bool = false
var public_direction: Vector2
var is_physical_damage_immune: bool = false
const DAMAGE_GROUP: StringName = "player"
@onready var hp: float = health
@onready var dash_timer = $DashTimer
@onready var attack_component: PlayerAttackComponent = $AttackComponent
@onready var start_position: Vector2 = global_position
@onready var cooldown_bar: ProgressBar = $PlayerCanvasLayer/CooldownBar
@onready var biscuit_count_label: Label = $"../CanvasLayer/GUI/HBoxContainer/BiscuitCountLabel"




func move(delta: float):
	var direction: Vector2
	if not is_dashing:
		direction = Input.get_vector(
			"walk_left", "walk_right", "walk_up", "walk_down"
		)
	else:
		direction = dash_direction
	
	if direction != Vector2.ZERO: 
		public_direction = direction
	

	if Input.is_action_just_pressed("dash"):
		dash_timer.start()
		is_dashing = true
		dash_direction = direction
	
	if is_dashing:
		var progress: float = (dash_timer.wait_time - dash_timer.time_left)/ dash_timer.wait_time
		velocity = dash_speed * dash_graph.sample(progress) * direction

	else:
		var active_speed: float = speed
		if Input.is_action_pressed("sprint"):	active_speed = sprint_speed
		#velocity = active_speed * direction
		velocity.x = move_toward(velocity.x, active_speed * direction.x, active_speed / acc_time * delta)
		velocity.y = move_toward(velocity.y, active_speed * direction.y, active_speed / acc_time * delta)
	
	
	move_and_slide()
	

func _ready() -> void:
	if get_tree().current_scene.name != "World": return
	cooldown_bar.min_value = 0
	biscuit_count_label.text = "Biscuit count: " + str(biscuits)
	

func _process(delta: float) -> void:
	cooldown_bar.max_value = attack_component.cool_down_timer.wait_time
	cooldown_bar.value = cooldown_bar.max_value - attack_component.cool_down_timer.time_left if !attack_component.cool_down_timer.is_stopped() else 1.0
	biscuit_count_label.text = "Biscuit count: " + str(biscuits)

func _physics_process(delta: float) -> void:
	move(delta)
	if Input.is_action_just_pressed("attack"): attack_component.attack()

func die():
	print("%s died" % name)
	hp = health
	global_position = get_random_spawn_position()

func _on_dash_exited() -> void:
	is_dashing = false

func recieve_damage(dmg: int):
	if is_physical_damage_immune: return
	hp -= dmg
	print("%s damage taken by %s (%s hp left)" % [dmg, name, hp])
	if hp <= 0:
		die()


func get_random_spawn_position():
	if !spawn_points: return start_position
	seed(randi())
	var random_id_value = roundi(randf() * (spawn_points.get_child_count() -  1))
	return spawn_points.get_child(random_id_value).global_position
