extends Panel

var items: Array[Weapon] = []
@export var player: Player
@onready var slot_container: HBoxContainer = $HotbarSlotContainer
@onready var item_select_frame: TextureRect = $ItemSelectFrame
const WEAPON_ICON = preload("res://Items/weapon_icon.tscn")
var item_positions: Dictionary[Weapon, Vector2] = {}
@onready var frame_init_pos = global_position
var frame_offset: Vector2 = Vector2(size.y/2, size.y/2)

func update_hotbar(active_weapon: Weapon = null):
	var player_weapons: Array[Weapon] = player.attack_component.available_weapons
	var selected_weapon: Weapon = player.attack_component.active_weapon
	
	#if items == player_weapons: return
	var items_to_include: Array[Weapon]
	
	for item: Weapon in player_weapons:
		if not item in items:
			items.append(item)
			var weapon_slot: TextureRect = WEAPON_ICON.instantiate()
			slot_container.add_child(weapon_slot)
			weapon_slot.texture = item.icon
			weapon_slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			weapon_slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
			item_positions.set(item, weapon_slot.global_position) 
		if item == selected_weapon:
			item_select_frame.global_position = frame_init_pos + Vector2(size.y * items.find(item), 0)
	size.x = slot_container.get_child_count() * size.y
	slot_container.size.x = slot_container.get_child_count() * size.y
	item_select_frame.size = Vector2(128,128)

func _ready() -> void:
	call_deferred("initialize")

func _input(event: InputEvent) -> void:
	var weapon_id: int = 404
	if Input.is_key_pressed(KEY_1): weapon_id = 0
	elif Input.is_key_pressed(KEY_2): weapon_id = 1
	elif Input.is_key_pressed(KEY_3): weapon_id = 2
	elif Input.is_key_pressed(KEY_4): weapon_id = 3
	elif Input.is_key_pressed(KEY_5): weapon_id = 4
	elif Input.is_key_pressed(KEY_6): weapon_id = 5
	elif Input.is_key_pressed(KEY_7): weapon_id = 6
	elif Input.is_key_pressed(KEY_8): weapon_id = 7
	elif Input.is_key_pressed(KEY_9): weapon_id = 8
	elif Input.is_key_pressed(KEY_0): weapon_id = 9
	player.attack_component.select_weapon(weapon_id)
	

func initialize():
	update_hotbar()
	item_select_frame.global_position = frame_init_pos + Vector2(0, 0)
	player.attack_component.weapons_updated.connect(update_hotbar)
