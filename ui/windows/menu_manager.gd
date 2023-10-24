class_name MenuManager
extends Control

@onready var user_menu: UserMenu = $"User Menu" as UserMenu

func _ready() -> void:
	user_menu.closed.connect(_on_user_menu_closed)
	pass

func open_user_menu() -> void:
	user_menu.show()

func close_all() -> void:
	pass

func _on_user_menu_closed() -> void:
	user_menu.hide()
