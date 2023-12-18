class_name Save
extends RefCounted

var id: int
var name: String
var author: String
var model: String
var created_at: String

func serialize() -> Dictionary:
	return {
		"save_id": id,
		"name": name,
		"author": author,
		"model": model,
		"created_at": created_at
	}

static func create_from_json(json: Dictionary) -> Save:
	var save = Save.new()
	save.id = json["save_id"]
	
	if json.has("id"):
		save.id = json["id"]
	
	save.name = json["name"]
	save.author = json["author"]
	save.model = json["model"]
	save.created_at = json["created_at"]
	return save

static func create_from_response(response: HTTPResponse) -> Array[Save]:
	var result: Array[Save]
	if response.content is Array:
		for person_line in response.content:
			result.append(Save.create_from_json(person_line))
	elif response.content != null:
		result.append(Save.create_from_json(response.content))
	return result
