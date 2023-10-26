class_name WindowsManager
extends Control

@onready var navigation_bar: LineMenuGroup = $"Windows Content/Navigation Left Bar" as LineMenuGroup

@onready var users_window: UsersWindow = $"Windows Content/Users Window" as UsersWindow
@onready var roles_window: RolesWindow = $"Windows Content/Roles Window" as RolesWindow
@onready var models_window: ModelsWindow = $"Windows Content/Models Window" as ModelsWindow
@onready var restarts_window: RestartsWindow = $"Windows Content/Restarts Window" as RestartsWindow
@onready var screens_window: ScreensWindow = $"Windows Content/Screens Window" as ScreensWindow
@onready var scenarios_window: ScenariosWindow = $"Windows Content/Scenarios Window" as ScenariosWindow
@onready var servers_window: ServersWindow = $"Windows Content/Servers Window" as ServersWindow

@onready var menu_manager: MenuManager = $"Menu Manager" as MenuManager

@onready var windows: Dictionary = {
	WindowId.Users		: users_window,
	WindowId.Roles		: roles_window,
	WindowId.Models		: models_window,
	WindowId.Restarts	: restarts_window,
	WindowId.Screens	: screens_window,
	WindowId.Scenarios	: scenarios_window,
	WindowId.Servers	: servers_window,
}

var current: Control

func _ready() -> void:
	for window_id in windows:
		windows[window_id].opened_menu.connect(func(tag: String): menu_manager.open(tag))
	
	for menu_id in menu_manager.menus:
		menu_manager.menus[menu_id].saved.connect(func(data): windows[menu_id].add(data))
	
	navigation_bar.button_pressed.connect(_on_navigation_button_pressed)

func _on_navigation_button_pressed(tag: String) -> void:
	if current != null:
		current.hide()
	
	current = windows[tag]
	current.show()
