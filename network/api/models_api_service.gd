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

func upload_file(model_id: int, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	const endpoint_argument_name: String = "model_file"
	var endpoint: String = url + "/" + str(model_id) + "/file"
	var form: FormData = FormData.with_file(endpoint_argument_name, file_name, file_type, file_base64)
	return await http.send_raw(endpoint, form.headers, HTTPClient.METHOD_POST, form.body)

## Download file, content in HTTPResponse has PackedByteArray with raw file data
func download_file(model_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(model_id) + "/file"
	var response = await http.download(endpoint)
	return response

func _parse_models_from_json(json_data: Array) -> Array[Model]:
	var answer: Array[Model]
	for data in json_data:
		answer.append(Model.create_from_json(data))
	return answer
