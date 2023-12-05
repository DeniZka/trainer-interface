class_name Screen
extends RefCounted

var id: int
var name: String
var author_id: int
var model_id: int
var created_at: String

func _to_string() -> String:
	return "Screen #%s: %s by %s for model #%s; Created at: %s" % [id, name, author_id, model_id, created_at]

static func create_from_json(json: Dictionary) -> Screen:
	var screen: Screen = Screen.new()
	screen.id = json["screen_id"]
	screen.name = json["name"]
	screen.author_id = json["author_id"]
	screen.model_id = json["model_id"]
	screen.created_at = json["created_at"]
	return screen
