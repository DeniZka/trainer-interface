class_name PersonsWindow
extends Control

signal opened_menu(data: Person)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: PersonsTable = %"Persons Table" as PersonsTable

var roles_by_id: Dictionary
var persons_service: PersonsService
var roles_service: RolesService

func _ready() -> void:
	persons_service = Services.persons as PersonsService
	roles_service = Services.roles as RolesService
	
	search_bar.add_button_pressed.connect(_on_add_button_pressed)
	table.edited.connect(_on_row_edited)
	table.selected.connect(_on_row_selected)
	table.deleted.connect(_on_row_deleted)
	persons_service.updated.connect(_on_persons_updated)

func open() -> void:
	Log.trace("Открыл окно пользователей")
	await roles_service.refresh(1, 25)
	await persons_service.refresh(1, 25)

func close() -> void:
	Log.trace("Закрыл окно пользователей")

func add(person: Person) -> void:
	table.add(person)

func _on_persons_updated() -> void:
	table.clear()
	table.add_array(persons_service.persons)
	Log.trace("Обновил отображение пользователей в таблице")

func _on_row_edited(row: PersonRow) -> void:
	opened_menu.emit(row.person)

func _on_row_selected(row: PersonRow) -> void:
	pass

func _on_row_deleted(row: PersonRow) -> void:
	var response = await persons_service.delete(row.person)

func _on_add_button_pressed() -> void:
	opened_menu.emit(null)
