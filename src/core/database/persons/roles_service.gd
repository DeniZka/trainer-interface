class_name RolesService
extends RefCounted

signal updated()

var api: RolesApiService
var roles: Dictionary

func _init(api: RolesApiService) -> void:
	self.api = api

func refresh(page: int, size: int) -> Array[PersonRole]:
	Log.debug("Обновление ролей (page %s, size %s)" % [page, size])
	var result = await api.get_roles(page, size)
	
	if result != []:
		roles.clear()
		for role in result:
			roles[role.id] = role
		updated.emit()
		return result
	return []

func add(new_role: PersonRole) -> void:
	Log.debug("Создание новой роли %s" % new_role.id)
	var created_role: PersonRole = await api.create_role(new_role)
	if created_role != null:
		Log.debug("Создание роли #%s прошло успешно" % new_role.id)
		roles[created_role.id] = created_role
		updated.emit()

func update(updated_role: PersonRole) -> void:
	Log.debug("Обновление данных у роли %s" % updated_role.id)
	var result: PersonRole = await api.update_role(updated_role)
	if result != null:
		Log.debug("Обновление данных у роли %s прошло успешно" % updated_role.id)
		roles[updated_role.id] = result
		updated.emit()

func get_cached_roles() -> Array[PersonRole]:
	var array: Array[PersonRole]
	for id in roles.keys():
		array.append(roles[id])
	return array

func get_cached_role_or_null(role_id: int) -> PersonRole:
	if roles.has(role_id):
		return roles[role_id]
	return null
