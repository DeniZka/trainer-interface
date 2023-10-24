class_name MenuManager
extends Control

@onready var user_menu: UserMenu = $"User Menu" as UserMenu
@onready var role_menu: RoleMenu = $"Role Menu" as RoleMenu

var opened_menu: Control

func _ready() -> void:
	user_menu.closed.connect(_on_menu_closed)
	role_menu.closed.connect(_on_menu_closed)

func open_user_menu() -> void:
	open_menu(user_menu)

func open_role_menu() -> void:
	open_menu(role_menu)

func open_menu(menu: Control) -> void:
	if opened_menu != null:
		opened_menu.hide()
	opened_menu = menu
	opened_menu.show()

func _on_menu_closed() -> void:
	opened_menu.hide()
