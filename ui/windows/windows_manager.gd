class_name WindowsManager
extends Control

@onready var navigation_bar: LineMenuGroup = $"Windows Content/Navigation Left Bar" as LineMenuGroup
@onready var users_window: UsersWindow = $"Windows Content/Users Window" as UsersWindow
@onready var menu_manager: MenuManager = $"Menu Manager" as MenuManager

func _ready() -> void:
	users_window.opened_add_user_menu.connect(_opened_add_user_menu)
	menu_manager.user_menu.saved.connect(_on_user_saved)
	navigation_bar.button_pressed.connect(_on_navigation_button_pressed)

func _opened_add_user_menu() -> void:
	menu_manager.open_user_menu()

func _on_user_saved(data: UserData) -> void:
	users_window.add_user(data)

func _on_navigation_button_pressed(tag: String) -> void:
	if tag == "Users":
		users_window.show()
	else:
		users_window.hide()
