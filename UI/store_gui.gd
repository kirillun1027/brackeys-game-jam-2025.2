extends Control
class_name StoreGUI

@onready var sold_out_label: Label = $SoldOutLabel
@onready var item_displays: VBoxContainer = $ItemDisplays
const DISPLAY_ROW_CONTAINER = preload("uid://djnyqox371l1s")

var items: Array[WeaponProperties] = [
	Global.RED,
	Global.PURPLE
]


func _ready() -> void:
	for item in items:
		var new_container: DisplayRowContainer = DISPLAY_ROW_CONTAINER.instantiate()
		new_container.item = item
		item_displays.add_child(new_container)
	for child in item_displays.get_children():
		child.item_display_row.item_purchased.connect(on_child_disconnected)

func on_child_disconnected():
	if get_child_count() == 1:
		sold_out_label.show()
