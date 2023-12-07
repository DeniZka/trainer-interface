class_name PersonsService
extends Node

signal updated()

var persons: Array[Person]
var api: PersonsApiService

func _init(apiService: PersonsApiService) -> void:
	self.api = apiService

func refresh(page: int, size: int) -> Array[Person]:
	Log.debug("Обновление данных пользователей (page %s, size %s)" % [page, size])
	var result = await api.get_persons(page, size)
	
	if result != []:
		persons = result
		
		for person in persons:
			_apply_roles_for(person)
		
		updated.emit()
		return result
	return []

func _apply_roles_for(person: Person) -> void:
	var roles: RolesService = Services.roles as RolesService
	var applied_roles: Array[PersonRole]
	for role_id in person.role_ids:
		var role: PersonRole = roles.get_cached_role_or_null(role_id)
		if role != null:
			applied_roles.append(role)
	person.apply_roles(applied_roles)

func add(new_person: Person) -> void:
	Log.debug("Создание нового пользователя %s" % new_person.id)
	var created_person: Person = await api.create_person(new_person)
	if created_person != null:
		Log.debug("Создание пользователя #%s прошло успешно" % new_person.id)
		persons.append(created_person)
		updated.emit()

func update(updated_person: Person) -> void:
	Log.debug("Обновление данных у пользователя %s" % updated_person.id)
	var result: Person = await api.update_person(updated_person.id, updated_person)
	if result != null:
		Log.debug("Обновление данных у пользователя %s прошло успешно" % updated_person.id)
		var index: int = persons.find(updated_person)
		persons[index] = result
		updated.emit()

func delete(person: Person) -> void:
	Log.debug("Удаление пользователя #%s" % person.id)
	var response = await api.delete_person(person.id)
	if response.is_success():
		Log.debug("Удаление пользователя #%s прошло успешно" % person.id)
		persons.erase(person)
		updated.emit()
	else:
		Log.error("Ошибка в удалении пользователя #%s, %s" % [person.id, response])
