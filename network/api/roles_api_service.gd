class_name RolesApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url
	self.http = http

## Get roles from database
func get_roles(page: int, size: int) -> Array[PersonRole]:
	var endpoint: String = Url.with_parameters(url + "/roles", { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if response.content == null:
		return []
	
	var roles = _parse_roles_from_json(response.content["items"])
	return roles

func _parse_roles_from_json(json_data: Array) -> Array[PersonRole]:
	var answer: Array[PersonRole]
	for data in json_data:
		answer.append(PersonRole.create_from_json(data))
	return answer
