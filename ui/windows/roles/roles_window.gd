class_name RolesWindow
extends Control

signal opened_role_menu()

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: RolesTable = %"Roles Table" as RolesTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add_role(role: RoleData) -> void:
	table.add_role(role)

func _on_add_button_pressed() -> void:
	opened_role_menu.emit()
