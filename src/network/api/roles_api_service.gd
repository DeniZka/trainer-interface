class_name RolesApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url + "/roles"
	self.http = http

## Get roles from database
func get_roles(page: int, size: int) -> Array[PersonRole]:
	var endpoint: String = Url.with_parameters(url, { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if not response.is_success():
		return []
	
	var roles = _parse_roles_from_json(response.content["items"])
	return roles

## Create new role and return it with id from database
func create_role(new_role: PersonRole) -> PersonRole:
	var serialized_person = new_role.serialize()
	serialized_person.erase("role_id")
	var endpoint: String = Url.with_parameters(url, serialized_person)
	var response = await http.send_post(endpoint);
	
	if not response.is_success():
		return null
	
	return PersonRole.create_from_json(response.content);

## Update role and return updated role from database
func update_role(updated_role: PersonRole) -> PersonRole:
	var serialized_person = updated_role.serialize()
	serialized_person.erase("role_id")
	var endpoint: String = Url.with_parameters(url + "/" + str(updated_role.id) + "/", serialized_person)
	var response = await http.send_patch(endpoint);
	
	if not response.is_success():
		return null
	
	return PersonRole.create_from_json(response.content);

## Delete role and return status code (200 - OK, 404 - Not Found)
func delete_role(role_id: int) -> int:
	var endpoint: String = url + "/" + str(role_id)
	var response = await http.send_delete(endpoint)
	return response.code

## Get role by id
func get_role(role_id: int) -> PersonRole:
	var endpoint: String = url + "/" + str(role_id)
	var response = await http.send_get(endpoint)
	
	if not response.is_success():
		return null
	
	return PersonRole.create_from_json(response.content)

func _parse_roles_from_json(json_data: Array) -> Array[PersonRole]:
	var answer: Array[PersonRole]
	for data in json_data:
		answer.append(PersonRole.create_from_json(data))
	return answer
