extends Area2D
class_name AttackArea

var source_weapon: Weapon
var source_entity: Node
signal enemy_died()



func attack(body: Node, dmg: int):
	if body.is_in_group("damagable") and source_entity.DAMAGE_GROUP != body.DAMAGE_GROUP: 
		body.recieve_damage(dmg)
		if body is Enemy:
			var on_enemy_death: Callable = func():	enemy_died.emit()
			if body.died.is_connected(on_enemy_death): return
			body.died.connect(on_enemy_death)
		return
	if body is Player and body.name != source_entity.name: 
		body.recieve_damage(dmg)
		return
