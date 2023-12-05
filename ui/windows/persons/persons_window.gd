class_name PersonsWindow
extends Control

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: PersonsTable = %"Persons Table" as PersonsTable

var roles_by_id: Dictionary

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add(person: Person) -> void:
	table.add(person)

func update() -> void:
	var persons = await Api.persons.get_persons(1, 25)
	table.clear()
	for person in persons:
		add(person)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Persons)
