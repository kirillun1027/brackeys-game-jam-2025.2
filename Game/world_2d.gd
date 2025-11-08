extends Node2D

const MAIN_MENU: String = "res://Game/main_menu.tscn"
@export var EntityPool: Node
@export var player: Player
const DEFAULT_CURSOR = preload("res://Assets/Player/WhiteCrosshairCircle8x8x.png")


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("leave"):
		Global.game_controller.change_scene_to(MAIN_MENU, false)

func _process(_delta: float) -> void:
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
