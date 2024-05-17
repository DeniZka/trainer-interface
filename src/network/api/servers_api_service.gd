class_name ServerApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url + "/servers"
	self.http = http

func get_servers(page: int, size: int) -> Array[Server]:
	var endpoint: String = Url.with_parameters(url, {"page": page, "size": size})
	var response: HTTPResponse = await http.send_get(endpoint)
	
	if not response.is_success():
		return []
	
	return _parse_servers_from_json(response.content["items"])

func add_server(server: Server) -> Server:
	var serialized: Dictionary = server.serialize()
	serialized.erase("server_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url, serialized)
	var response: HTTPResponse = await http.send_post(endpoint)
	
	if not response.is_success():
		return null
	
	return Server.create_from_json(response.content)

func update_server(server_id: int, updated_server: Server) -> Server:
	var serialized = updated_server.serialize()
	serialized.erase("server_id")
	serialized.erase("created_at")
	var endpoint: String = Url.with_parameters(url + "/" + str(server_id) +"/", serialized)
	var response = await http.send_patch(endpoint);
	
	if not response.is_success():
		return null
	
	return Server.create_from_json(response.content);

func _parse_servers_from_json(json_data: Array) -> Array[Server]:
	var answer: Array[Server]
	for data in json_data:
		answer.append(Server.create_from_json(data))
	return answer
