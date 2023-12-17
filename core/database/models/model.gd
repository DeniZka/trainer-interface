class_name Model
extends RefCounted

var id: int
var name: String
var author: String
var created_at: String

func _to_string() -> String:
	return "Model #%s: %s by %s; Created at: %s." % [id, name, author, created_at]

func serialize() -> Dictionary:
	return {
		"model_id": id,
		"name": name,
		"author": author,
		"created_at": created_at
	}

static func create_from_json(json: Dictionary) -> Model:
	var model: Model = Model.new()
	model.id = json["model_id"]
	
	if json.has("id"):
		model.id = json["id"]
	
	model.name = json["name"]
	model.author = json["author"]
	model.created_at = json["created_at"]
	return model

static func create_from_response(response: HTTPResponse) -> Array[Model]:
	var result: Array[Model]
	if response.content is Array:
		for person_line in response.content:
			result.append(Model.create_from_json(person_line))
	elif response.content != null:
		result.append(Model.create_from_json(response.content))
	return result
