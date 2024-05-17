class_name SavesApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url + "/saves"
	self.http = http

## Get all users from database
func get_saves(page: int, size: int) -> Array[Save]:
	var endpoint: String = Url.with_parameters(url, { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if response == null:
		return []
	
	return _parse_models_from_json(response.content["items"])

## Create new save in database and return save with unique id
func create_save(save: Save) -> Save:
	var serialized: Dictionary = save.serialize()
	serialized.erase("save_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url, serialized)
	var response = await http.send_post(endpoint)
	
	if response.is_error():
		return null
	
	return Save.create_from_json(response.content)

## Update save in database
func update_save(save: Save) -> Save:
	var serialized: Dictionary = save.serialize()
	serialized.erase("save_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url + "/" + str(save.id) + "/", serialized)
	var response = await http.send_patch(endpoint)
	
	if response.is_error():
		return null
	
	return Save.create_from_json(response.content)

## Upload save data file (using FormData template) to database
func upload_file(save_id: int, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	var endpoint: String = url + "/" + str(save_id) + "/file"
	return await http.upload_file(endpoint, file_name, file_type, file_base64)

## Download save data file from database
func download_file(save_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(save_id) + "/file"
	return await http.download_file(endpoint)

## Delete save from database
func delete_save(save_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(save_id)
	return await http.send_delete(endpoint)

func _parse_models_from_json(json_data: Array) -> Array[Save]:
	var answer: Array[Save]
	for data in json_data:
		answer.append(Save.create_from_json(data))
	return answer
