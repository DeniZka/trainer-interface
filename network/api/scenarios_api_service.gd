class_name ScenariosApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url + "/scenarios"
	self.http = http

## Get all users from database
func get_scenarios(page: int, size: int) -> Array[Scenario]:
	var endpoint: String = Url.with_parameters(url, { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if response.is_error():
		return []
	
	return _parse_models_from_json(response.content["items"])

## Create new scenario in database and return it with unique id
func create_scenario(new_scenario: Scenario) -> Scenario:
	var serialized = new_scenario.serialize()
	serialized.erase("scenario_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url, serialized)
	var response = await http.send_post(endpoint)
	
	if not response.is_success():
		return null
	
	return Scenario.create_from_json(response.content)

func update_scenario(scenario: Scenario) -> Scenario:
	var serialized = scenario.serialize()
	serialized.erase("scenario_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url + "/" + str(scenario.id), serialized)
	var response = await http.send_patch(endpoint)
	
	if not response.is_success():
		return null
	
	return Scenario.create_from_json(response.content)

## Upload scenario file to database
func upload_file(scenario_id: int, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	var endpoint: String = url + "/" + str(scenario_id) + "/file"
	return await http.upload_file(endpoint, file_name, file_type, file_base64)

## Download file, content in HTTPResponse has PackedByteArray with raw file data
func download_file(scenario_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(scenario_id) + "/file"
	var response = await http.download_file(endpoint)
	return response

func _parse_models_from_json(json_data: Array) -> Array[Scenario]:
	var answer: Array[Scenario]
	for data in json_data:
		answer.append(Scenario.create_from_json(data))
	return answer
