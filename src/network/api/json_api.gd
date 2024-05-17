class_name JSONApi
extends RefCounted

signal updated()

var url: String
var view_url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url
	self.view_url = url + "/view"
	self.http = http

func all() -> HTTPResponse:
	var response: HTTPResponse = await http.send_get(view_url);
	return response.parse_as_json()

func get_all(page: int, size: int) -> HTTPResponse:
	var url_with_parameters: String = Url.with_parameters(view_url, { "page": page, "size": size })
	var response: HTTPResponse = await http.send_get(url_with_parameters)
	return response.parse_as_json()

func get_by_id(id: int) -> HTTPResponse:
	var response: HTTPResponse = await http.send_get(view_url + "/" + str(id))
	return response.parse_as_json()

func create(data: Dictionary) -> HTTPResponse:
	var endpoint: String = Url.with_parameters(url, data)
	var response: HTTPResponse = await http.send_post(endpoint)
	#var response: HTTPResponse = await http.send_raw(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, endpoint.to_utf8_buffer())
	updated.emit()
	return response.parse_as_json()

func update(id: int, data: Dictionary) -> HTTPResponse:
	var json = JSON.stringify(data, "", false)
	var response: HTTPResponse = await http.send_raw(url + "/" + str(id), ["Content-Type: application/json"], HTTPClient.METHOD_PUT, json.to_utf8_buffer())
	updated.emit()
	return response.parse_as_json()

func delete(id: int) -> HTTPResponse:
	var response: HTTPResponse = await http.send_delete(url + "/" + str(id))
	updated.emit()
	return response.parse_as_json()

func upload_file(id: int, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	var endpoint: String = url + "/" + str(id) + "/file"
	return await http.upload_file(endpoint, file_name, file_type, file_base64)

func download_file(id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(id) + "/file"
	var response = await http.download_file(endpoint)
	return response
