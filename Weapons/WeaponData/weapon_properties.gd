extends Resource
class_name WeaponProperties

@export var damage: int
@export var attack_type: AttackTypes
@export var lifetime: float
@export var cooldown: float
@export var attack_area: PackedScene
@export var cost: int
@export var icon: Texture
@export var name: StringName



enum AttackTypes{
	MELEE,
	RANGED,
	NEUTRAL,
}
