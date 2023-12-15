class_name Server
extends RefCounted

var id: int
var name: String
var author_id: int
var model_id: int
var created_at: String

func serialize() -> Dictionary:
	return {
		"server_id": id,
		"name": name,
		"author_id": author_id,
		"model_id": model_id,
		"created_at": created_at,
	}

static func create_from_json(json: Dictionary) -> Server:
	var server: Server = Server.new()
	server.id = json["server_id"]
	server.name = json["name"]
	server.author_id = json["author_id"]
	server.model_id = json["model_id"]
	server.created_at = json["created_at"]
	return server
