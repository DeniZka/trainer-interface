extends Node

var test_value: int = 10

signal updated()

var persons: Array[Person]
var api: PersonsApiService

func _ready() -> void:
	api = Api.persons

func update() -> void:
	var persons = await api.get_persons(1, 25)
	updated.emit()

func add(new_person: Person) -> void:
	var created_person: Person = await api.create_person(new_person)
	if created_person != null:
		persons.append(created_person)
	updated.emit()

func delete(person: Person) -> void:
	var response = await api.delete_person(person.id)
	if response.is_success():
		persons.erase(person)
		updated.emit()
