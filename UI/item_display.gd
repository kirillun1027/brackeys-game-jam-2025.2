extends HBoxContainer
class_name ItemDisplayRow

var item_display: TextureRect
var price_panel: Panel
@onready var item: WeaponProperties = get_parent().item
const EMPTY_WEAPON = preload("res://Weapons/WeaponData/empty_weapon.tres")
var purchase_button: Button
var store: Store
var player: Player
signal item_purchased()



func _ready() -> void:
	player = get_tree().current_scene.get_child(0).player
	for child in get_children():
		if child is TextureRect:
			item_display = child
			item_display.texture = item.icon
			purchase_button = item_display.get_node("PurchaseButton")
			purchase_button.pressed.connect(on_item_purchased)
		elif child is Panel:
			price_panel = child
			var price_label = price_panel.get_child(0)
			if price_label is Label:
				price_label.text = str(item.cost) + " Biscuits"

func on_item_purchased() -> void:
	var player_weapon_handler: PlayerAttackComponent = player.attack_component
	
	if player.biscuits < item.cost: return
	player_weapon_handler.add_weapon(item)
	player.biscuits -= item.cost
	item_purchased.emit()
	queue_free()
