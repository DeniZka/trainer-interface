class_name ScreensApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url + "/screen"
	self.http = http

## Get all users from database
func get_screens(page: int, size: int) -> Array[Screen]:
	var endpoint: String = Url.with_parameters(url, { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if not response.is_success():
		return []
	
	return _parse_models_from_json(response.content["items"])

## Create new screen in database and return it with unique id
func create_screen(new_screen: Screen) -> Screen:
	var serialized = new_screen.serialize()
	serialized.erase("screen_id")
	serialized.erase("created_at")
	
	var endpoint: String = Url.with_parameters(url, serialized)
	var response = await http.send_post(endpoint)
	
	if not response.is_success():
		return null
	
	return Screen.create_from_json(response.content)

func update_screen(updated_screen: Screen) -> Screen:
	var serialized = updated_screen.serialize()
	serialized.erase("screen_id")
	serialized.erase("created_at")
	
	var endpoint: String = Url.with_parameters(url + "/" + str(updated_screen.id) + "/", serialized)
	var response = await http.send_patch(endpoint)
	
	if not response.is_success():
		return null
	
	return Screen.create_from_json(response.content)

## Upload scenario file to database
func upload_file(screen_id: int, file_name: String, file_type: String, file_base64: String) -> HTTPResponse:
	var endpoint: String = url + "/" + str(screen_id) + "/file"
	return await http.upload_file(endpoint, file_name, file_type, file_base64)

## Download file, content in HTTPResponse has PackedByteArray with raw file data
func download_file(screen_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(screen_id) + "/file"
	var response = await http.download_file(endpoint)
	return response

func add_person(screen_id: int, person_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(screen_id) + "/" + str(person_id)
	return await http.send_put(endpoint)

func remove_person(screen_id: int, person_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(screen_id) + "/" + str(person_id)
	return await http.send_delete(endpoint)

func add_role(screen_id: int, role_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(screen_id) + "/" + str(role_id)
	return await http.send_put(endpoint)

func remove_role(screen_id: int, role_id: int) -> HTTPResponse:
	var endpoint: String = url + "/" + str(screen_id) + "/" + str(role_id)
	return await http.send_delete(endpoint)

func _parse_models_from_json(json_data: Array) -> Array[Screen]:
	var answer: Array[Screen]
	for data in json_data:
		answer.append(Screen.create_from_json(data))
	return answer
