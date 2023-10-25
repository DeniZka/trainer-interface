class_name WindowsManager
extends Control

@onready var navigation_bar: LineMenuGroup = $"Windows Content/Navigation Left Bar" as LineMenuGroup

@onready var users_window: UsersWindow = $"Windows Content/Users Window" as UsersWindow
@onready var roles_window: RolesWindow = $"Windows Content/Roles Window" as RolesWindow
@onready var models_window: ModelsWindow = $"Windows Content/Models Window" as ModelsWindow
@onready var restarts_window: RestartsWindow = $"Windows Content/Restarts Window" as RestartsWindow

@onready var menu_manager: MenuManager = $"Menu Manager" as MenuManager

@onready var windows: Dictionary = {
	WindowId.Users		: users_window,
	WindowId.Roles		: roles_window,
	WindowId.Models		: models_window,
	WindowId.Restarts	: restarts_window,
}

var current: Control

func _ready() -> void:
	users_window.opened_user_menu.connect(func(): menu_manager.open(WindowId.Users))
	roles_window.opened_role_menu.connect(func(): menu_manager.open(WindowId.Roles))
	models_window.opened_role_menu.connect(func(): menu_manager.open(WindowId.Models))
	restarts_window.opened_restart_menu.connect(func(): menu_manager.open(WindowId.Restarts))
	
	menu_manager.user_menu.saved.connect(func(data: UserData): users_window.add_user(data))
	menu_manager.role_menu.saved.connect(func(data: RoleData): roles_window.add_role(data))
	menu_manager.model_menu.saved.connect(func(data: ModelData): models_window.add_model(data))
	menu_manager.restart_menu.saved.connect(func(data: RestartData): restarts_window.add_restart(data))
	
	navigation_bar.button_pressed.connect(_on_navigation_button_pressed)

func _on_navigation_button_pressed(tag: String) -> void:
	if current != null:
		current.hide()
	
	current = windows[tag]
	current.show()
