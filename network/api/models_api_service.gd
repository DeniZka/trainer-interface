class_name ModelsApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url + "/models"
	self.http = http

## Get all users from database
func get_models(page: int, size: int) -> Array[Model]:
	var endpoint: String = Url.with_parameters(url, { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if response == null:
		return []
	
	return _parse_models_from_json(response.content["items"])

## Create model and return it from database with unique id
func create_model(new_model: Model) -> Model:
	var serialized: Dictionary = new_model.serialize()
	serialized.erase("model_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url, serialized)
	var response = await http.send_post(endpoint)
	
	if response == null:
		return null
	
	return Model.create_from_json(response.content)

## Update existing model and return it from database
func update_model(updated_model: Model) -> Model:
	var serialized: Dictionary = updated_model.serialize()
	serialized.erase("model_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url + "/" + str(updated_model.id) + "/", serialized)
	var response = await http.send_patch(endpoint)
	
	if response == null:
		return null
	
	return Model.create_from_json(response.content)

func upload_file(model_id: int, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	var endpoint: String = url + "/" + str(model_id) + "/file"
	return await http.upload_file(endpoint, file_name, file_type, file_base64)

## Download file, content in HTTPResponse has PackedByteArray with raw file data
func download_file(model_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(model_id) + "/file"
	var response = await http.download_file(endpoint)
	return response

func delete_model(model_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(model_id)
	var response = await http.send_delete(endpoint)
	return response

func _parse_models_from_json(json_data: Array) -> Array[Model]:
	var answer: Array[Model]
	for data in json_data:
		answer.append(Model.create_from_json(data))
	return answer
