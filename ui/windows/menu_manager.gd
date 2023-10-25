class_name MenuManager
extends Control

@onready var user_menu: UserMenu = $"User Menu" as UserMenu
@onready var role_menu: RoleMenu = $"Role Menu" as RoleMenu
@onready var model_menu: ModelMenu = $"Model Menu" as ModelMenu
@onready var restart_menu: RestartMenu = $"Restart Menu" as RestartMenu
@onready var screen_menu: ScreenMenu = $"Screen Menu" as ScreenMenu

@onready var menus = {
	WindowId.Users		: user_menu,
	WindowId.Roles		: role_menu,
	WindowId.Models		: model_menu,
	WindowId.Restarts	: restart_menu,
	WindowId.Screens	: screen_menu,
}

var opened_menu: Control

func _ready() -> void:
	for menu_id in menus:
		menus[menu_id].closed.connect(_on_menu_closed)

func open(window_id: String) -> void:
	var next_menu: Control = menus[window_id]
	_open_menu(next_menu)

func _open_menu(menu: Control) -> void:
	if opened_menu != null:
		opened_menu.hide()
	opened_menu = menu
	opened_menu.show()

func _on_menu_closed() -> void:
	opened_menu.hide()
