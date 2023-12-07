extends Node

var persons: PersonsService

func _ready() -> void:
	persons = PersonsService.new(Api.persons)

func get_persons() -> PersonsService:
	return persons;
