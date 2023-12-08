class_name RolesWindow
extends BaseWindow

signal opened_menu(role: PersonRole)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: RolesTable = %"Roles Table" as RolesTable

var roles: RolesService

func _ready() -> void:
	roles = Services.roles as RolesService
	search_bar.add_button_pressed.connect(_on_add_button_pressed)
	roles.updated.connect(_on_roles_updated)

func add(role: PersonRole) -> void:
	table.add_role(role)

func _on_roles_updated() -> void:
	table.clear()
	table.add_array(roles.get_cached_roles())

func open() -> void:
	super.open()
	await roles.refresh(1, 25)

func close() -> void:
	super.close()

func _on_add_button_pressed() -> void:
	opened_menu.emit(null)
