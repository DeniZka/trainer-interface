class_name JSONApi
extends RefCounted

signal updated()

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url
	self.http = http

func all() -> HTTPResponse:
	var response: HTTPResponse = await http.send_get(url);
	return response.parse_as_json()

func get_all(page: int, size: int) -> HTTPResponse:
	var url_with_parameters: String = Url.with_parameters(url, { "page": page, "size": size })
	var response: HTTPResponse = await http.send_get(url_with_parameters)
	return response.parse_as_json()

func get_by_id(id: int) -> HTTPResponse:
	var response: HTTPResponse = await http.send_get(url + "/" + str(id))
	return response.parse_as_json()

func create(data: Dictionary) -> HTTPResponse:
	var json = JSON.stringify(data, "", false)
	var response: HTTPResponse = await http.send_raw(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, json.to_utf8_buffer())
	updated.emit()
	return response.parse_as_json()

func update(id: int, data: Dictionary) -> HTTPResponse:
	var json = JSON.stringify(data, "", false)
	var response: HTTPResponse = await http.send_raw(url, ["Content-Type: application/json"], HTTPClient.METHOD_PUT, json.to_utf8_buffer())
	updated.emit()
	return response.parse_as_json()

func delete(id: int) -> HTTPResponse:
	var response: HTTPResponse = await http.send_delete(url)
	updated.emit()
	return response.parse_as_json()
