class_name Scenario
extends RefCounted

var id: int
var name: String
var author_id: int
var model_id: int
var created_at: String

func _to_string() -> String:
	return "Scenario #%s: %s by %s for model #%s; Created at: %s." % [id, name, author_id, model_id, created_at]

func serialize() -> Dictionary:
	return {
		"scenario_id": id,
		"name": name,
		"author_id": author_id,
		"model_id": model_id,
		"created_at": created_at
	}

static func create_from_json(json: Dictionary) -> Scenario:
	var scenario: Scenario = Scenario.new()
	scenario.id = json["scenario_id"]
	scenario.name = json["name"]
	scenario.author_id = json["author_id"]
	scenario.created_at = json["created_at"]
	return scenario
