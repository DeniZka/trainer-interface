class_name Model
extends RefCounted

var id: int
var name: String
var author_id: int
var created_at: String

func _to_string() -> String:
	return "Model #%s: %s by %s; Created at: %s." % [id, name, author_id, created_at]

func serialize() -> Dictionary:
	return {
		"model_id": id,
		"name": name,
		"author_id": author_id,
		"created_at": created_at
	}

static func create_from_json(json: Dictionary) -> Model:
	var model: Model = Model.new()
	model.id = json["model_id"]
	model.name = json["name"]
	model.author_id = json["author_id"]
	model.created_at = json["created_at"]
	return model
