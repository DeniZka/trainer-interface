class_name WindowsManager
extends Control

@onready var navigation_bar: LineMenuGroup = $"Windows Content/Navigation Left Bar" as LineMenuGroup

@onready var users_window: UsersWindow = $"Windows Content/Users Window" as UsersWindow
@onready var roles_window: RolesWindow = $"Windows Content/Roles Window" as RolesWindow

@onready var menu_manager: MenuManager = $"Menu Manager" as MenuManager

@onready var windows: Dictionary = {
	"Users": users_window,
	"Roles": roles_window
}

var current: Control

func _ready() -> void:
	users_window.opened_add_user_menu.connect(_opened_add_user_menu)
	roles_window.opened_role_menu.connect(_on_opened_role_menu)
	menu_manager.user_menu.saved.connect(_on_user_saved)
	menu_manager.role_menu.saved.connect(_on_role_saved)
	navigation_bar.button_pressed.connect(_on_navigation_button_pressed)

func _on_opened_role_menu() -> void:
	menu_manager.open_role_menu()

func _opened_add_user_menu() -> void:
	menu_manager.open_user_menu()

func _on_role_saved(data: RoleData) -> void:
	roles_window.add_role(data)

func _on_user_saved(data: UserData) -> void:
	users_window.add_user(data)

func _on_navigation_button_pressed(tag: String) -> void:
	if current != null:
		current.hide()
	
	current = windows[tag]
	current.show()
