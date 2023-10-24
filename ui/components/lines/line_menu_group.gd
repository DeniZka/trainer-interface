class_name LineMenuGroup
extends Control

signal button_pressed(tag: String)

@export var menus: Array[LineMenu]

func _ready() -> void:
	for menu in menus:
		menu.button_pressed.connect(_on_button_pressed)

func _on_button_pressed(tag: String, menu: LineMenu) -> void:
	for item in menus:
		if item != menu:
			item.unselect_all()
	button_pressed.emit(tag)
