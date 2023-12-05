class_name ModelsApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url
	self.http = http

## Get all users from database
func get_models(page: int, size: int) -> Array[Model]:
	var endpoint: String = Url.with_parameters(url + "/models", { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if response == null:
		return []
	
	return _parse_models_from_json(response.content["items"])

func _parse_models_from_json(json_data: Array) -> Array[Model]:
	var answer: Array[Model]
	for data in json_data:
		answer.append(Model.create_from_json(data))
	return answer
