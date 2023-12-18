class_name WindowsManager
extends Control

@onready var navigation_bar: LeftBar = $"Windows Content/Navigation Left Bar" as LineMenuGroup

@onready var persons_window: PersonsWindow = $"Windows Content/Persons Window" as PersonsWindow
@onready var roles_window: RolesWindow = $"Windows Content/Roles Window" as RolesWindow
@onready var models_window: ModelsWindow = $"Windows Content/Models Window" as ModelsWindow
@onready var restarts_window: RestartsWindow = $"Windows Content/Restarts Window" as RestartsWindow
@onready var screens_window: ScreensWindow = $"Windows Content/Screens Window" as ScreensWindow
@onready var scenarios_window: ScenariosWindow = $"Windows Content/Scenarios Window" as ScenariosWindow
@onready var servers_window: ServersWindow = $"Windows Content/Servers Window" as ServersWindow

@onready var menu_manager: MenuManager = $"Menu Manager" as MenuManager

@onready var login_form: LoginForm = $"../Login Form" as LoginForm

@onready var windows: Dictionary = {
	WindowId.Persons	: persons_window,
	WindowId.Roles		: roles_window,
	WindowId.Models		: models_window,
	WindowId.Restarts	: restarts_window,
	WindowId.Screens	: screens_window,
	WindowId.Scenarios	: scenarios_window,
	WindowId.Servers	: servers_window,
}

var current: BaseWindow

func _ready() -> void:
	for window_id in windows:
		windows[window_id].opened_menu.connect(func(data): menu_manager.open(window_id, data))
	
	navigation_bar.button_pressed.connect(_on_navigation_button_pressed)
	_update_server_list_on_navigation_bar()

func _update_server_list_on_navigation_bar() -> void:
	var servers: JSONApi = Api.servers
	var response: HTTPResponse = await servers.all()
	var servers_data = Server.create_from_response(response)
	navigation_bar.clear_servers()
	for data in servers_data:
		navigation_bar.add_server(data.name)

func _on_navigation_button_pressed(tag: String) -> void:
	if current != null:
		current.close()
	
	if windows.has(tag):
		current = windows[tag]
		current.open()
	else:
		Log.fatal("Окно \"%s\" не обнаружено в списке окон WindowsManager" % tag)
