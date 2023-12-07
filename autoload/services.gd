extends Node

var persons: PersonsService
var roles: RolesService

func _ready() -> void:
	persons = PersonsService.new(Api.persons)
	roles = RolesService.new(Api.roles)
