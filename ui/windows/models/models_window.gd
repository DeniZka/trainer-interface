class_name ModelsWindow
extends Control

signal opened_role_menu()

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: ModelsTable = %"Models Table" as ModelsTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add_model(role: ModelData) -> void:
	table.add_model(role)

func _on_add_button_pressed() -> void:
	opened_role_menu.emit()
