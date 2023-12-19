class_name Server
extends RefCounted

var id: int
var name: String
var author: String
var model: String
var available_roles: Array
var available_persons: Array
var created_at: String

func serialize() -> Dictionary:
	return {
		"server_id": id,
		"name": name,
		"author": author,
		"model": model,
		"roles_allowed": available_roles,
		"persons_allowed": available_persons,
		"created_at": created_at,
	}

func available_roles_to_string() -> String:
	return ArrayUtils.from_array_to_string(available_roles)

func available_persons_to_string() -> String:
	return ArrayUtils.from_array_to_string(available_persons)

static func create_from_json(json: Dictionary) -> Server:
	var server: Server = Server.new()
	server.id = json["server_id"]
	
	if json.has("id"):
		server.id = json["id"]
	
	server.name = json["name"]
	server.author = json["author"]
	server.model = json["model"]
	server.available_roles = json["roles_allowed"]
	server.available_persons = json["persons_allowed"]
	server.created_at = json["created_at"]
	return server

static func create_from_response(response: HTTPResponse) -> Array[Server]:
	var result: Array[Server]
	if response.content is Array:
		for person_line in response.content:
			result.append(Server.create_from_json(person_line))
	elif response.content != null:
		result.append(Server.create_from_json(response.content))
	return result
