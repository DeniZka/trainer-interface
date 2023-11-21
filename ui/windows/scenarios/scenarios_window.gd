class_name ScenariosWindow
extends Control

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: ScenariosTable = %"Scenarios Table" as ScenariosTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add(scenario: ScenarioData) -> void:
	table.add_scenario(scenario)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Scenarios)
