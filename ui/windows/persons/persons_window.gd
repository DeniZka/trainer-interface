class_name PersonsWindow
extends Control

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: PersonsTable = %"Persons Table" as PersonsTable

var roles_by_id: Dictionary

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)
	table.edited.connect(_on_row_edited)
	table.selected.connect(_on_row_selected)
	table.deleted.connect(_on_row_deleted)
	PersonProvider.updated.connect(_on_persons_updated)

func add(person: Person) -> void:
	table.add(person)

func _on_persons_updated() -> void:
	table.clear()
	table.add_array(PersonProvider.persons)

func update() -> void:
	var personsService = Api.persons;
	refresh_persons(personsService)

func refresh_persons(service: PersonsApiService) -> void:
	Log.debug("Обновление списка пользователей")
	var persons: Array[Person] = await service.get_persons(1, 25)
	
	if persons != null:
		table.clear()
		table.add_array(persons)

func _on_row_edited(row: PersonRow) -> void:
	pass

func _on_row_selected(row: PersonRow) -> void:
	pass

func _on_row_deleted(row: PersonRow) -> void:
	Log.info("Удаление пользователя #%s" % row.person.id)
	var response = await Api.persons.delete_person(row.person.id)
	update()

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Persons)
