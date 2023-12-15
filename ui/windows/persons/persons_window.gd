class_name PersonsWindow
extends BaseWindow

signal opened_menu(data: Person)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: PersonsTable = %"Persons Table" as PersonsTable

var roles_by_id: Dictionary
var persons_api: JSONApi

func _ready() -> void:
	persons_api = Api.persons
	
	search_bar.add_button_pressed.connect(_on_add_button_pressed)
	table.edited.connect(_on_row_edited)
	table.selected.connect(_on_row_selected)
	table.deleted.connect(_on_row_deleted)

func open() -> void:
	super.open()
	persons_api.updated.connect(_on_persons_updated)
	_on_persons_updated()

func close() -> void:
	persons_api.updated.disconnect(_on_persons_updated)
	super.close()

func _on_persons_updated() -> void:
	var response: HTTPResponse = await persons_api.all()
	var persons: Array[Person] = Person.create_from_response(response)
	table.clear()
	table.add_array(persons)
	Log.debug("Обновил отображение пользователей в таблице")

func _on_row_edited(row: PersonRow) -> void:
	opened_menu.emit(row.person)

func _on_row_selected(row: PersonRow) -> void:
	pass

func _on_row_deleted(row: PersonRow) -> void:
	var response = await persons_api.delete(row.person.id)

func _on_add_button_pressed() -> void:
	opened_menu.emit(null)
