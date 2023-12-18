class_name Scenario
extends RefCounted

var id: int
var name: String
var author: String
var model: String
var created_at: String

func serialize() -> Dictionary:
	return {
		"scenario_id": id,
		"name": name,
		"author": author,
		"model": model,
		"created_at": created_at
	}

static func create_from_json(json: Dictionary) -> Scenario:
	var scenario: Scenario = Scenario.new()
	scenario.id = json["scenario_id"]
	
	if json.has("id"):
		scenario.id = json["id"]
	
	scenario.name = json["name"]
	scenario.author = json["author"]
	scenario.model = json["model"]
	scenario.created_at = json["created_at"]
	return scenario

static func create_from_response(response: HTTPResponse) -> Array[Scenario]:
	var result: Array[Scenario]
	if response.content is Array:
		for person_line in response.content:
			result.append(Scenario.create_from_json(person_line))
	elif response.content != null:
		result.append(Scenario.create_from_json(response.content))
	return result
