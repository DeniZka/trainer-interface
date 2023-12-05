class_name RolesWindow
extends Control

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: RolesTable = %"Roles Table" as RolesTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add(role: PersonRole) -> void:
	table.add_role(role)

func update() -> void:
	var roles = await Api.roles.get_roles(1, 25)
	table.clear()
	for role in roles:
		add(role)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Roles)
