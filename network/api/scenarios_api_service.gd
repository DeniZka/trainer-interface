class_name ScenariosApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url
	self.http = http

## Get all users from database
func get_scenarios(page: int, size: int) -> Array[Scenario]:
	var endpoint: String = Url.with_parameters(url + "/scenarios", { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if response == null:
		return []
	
	return _parse_models_from_json(response.content["items"])

func _parse_models_from_json(json_data: Array) -> Array[Scenario]:
	var answer: Array[Scenario]
	for data in json_data:
		answer.append(Scenario.create_from_json(data))
	return answer
