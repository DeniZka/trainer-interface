class_name RolesWindow
extends BaseWindow

signal opened_menu(role: PersonRole)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: RolesTable = %"Roles Table" as RolesTable

var roles_api: JSONApi

func _ready() -> void:
	roles_api = Api.roles
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func _on_roles_updated() -> void:
	var response: HTTPResponse = await roles_api.all()
	var roles: Array[PersonRole] = PersonRole.create_from_response(response)
	table.clear()
	table.add_array(roles)

func open() -> void:
	super.open()
	roles_api.updated.connect(_on_roles_updated)
	_on_roles_updated()

func close() -> void:
	roles_api.updated.disconnect(_on_roles_updated)
	super.close()

func _on_add_button_pressed() -> void:
	opened_menu.emit(null)
