class_name Save
extends RefCounted

var id: int
var name: String
var author_id: int
var model_id: int
var created_at: String

func _to_string() -> String:
	return "Save #%s: %s by %s for model #%s; Created at: %s." % [id, name, author_id, model_id, created_at]

func serialize() -> Dictionary:
	return {
		"save_id": id,
		"name": name,
		"author_id": author_id,
		"model_id": model_id,
		"created_at": created_at
	}

static func create_from_json(json: Dictionary) -> Save:
	var save = Save.new()
	save.id = json["save_id"]
	save.name = json["name"]
	save.author_id = json["author_id"]
	save.model_id = json["model_id"]
	save.created_at = json["created_at"]
	return save
