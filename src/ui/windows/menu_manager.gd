class_name MenuManager
extends Control

@onready var person_menu: PersonMenu = $"Person Menu" as PersonMenu
@onready var role_menu: RoleMenu = $"Role Menu" as RoleMenu
@onready var model_menu: ModelMenu = $"Model Menu" as ModelMenu
@onready var restart_menu: RestartMenu = $"Restart Menu" as RestartMenu
@onready var screen_menu: ScreenMenu = $"Screen Menu" as ScreenMenu
@onready var scenario_menu: ScenarioMenu = $"Scenario Menu" as ScenarioMenu
@onready var server_menu: ServerMenu = $"Server Menu" as ServerMenu

@onready var menus = {
	WindowId.Persons	: person_menu,
	WindowId.Roles		: role_menu,
	WindowId.Models		: model_menu,
	WindowId.Restarts	: restart_menu,
	WindowId.Screens	: screen_menu,
	WindowId.Scenarios	: scenario_menu,
	WindowId.Servers	: server_menu,
}

var opened_menu: Control

func _ready() -> void:
	for menu_id in menus:
		menus[menu_id].closed.connect(_on_menu_closed)

func open(window_id: String, data: Variant) -> void:
	var next_menu: Control = menus[window_id]
	_open_menu(next_menu, data)

func _open_menu(menu: Control, data: Variant) -> void:
	if opened_menu != null:
		opened_menu.close()
	opened_menu = menu
	opened_menu.open(data)

func _on_menu_closed() -> void:
	opened_menu.close()
