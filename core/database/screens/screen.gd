class_name Screen
extends RefCounted

var id: int
var name: String
var author: String
var model: String
var created_at: String
var available_roles: Array
var available_persons: Array

func serialize() -> Dictionary:
	return {
		"screen_id": id,
		"name": name,
		"author": author,
		"model": model,
		"roles_allowed": available_roles,
		"persons_allowed": available_persons,
		"created_at": created_at
	}

func available_roles_to_string() -> String:
	return ArrayUtils.from_array_to_string(available_roles)

func available_persons_to_string() -> String:
	return ArrayUtils.from_array_to_string(available_persons)

static func create_from_json(json: Dictionary) -> Screen:
	var screen: Screen = Screen.new()
	screen.id = json["screen_id"]
	
	if json.has("id"):
		screen.id = json["id"]
	
	screen.name = json["name"]
	screen.author = json["author"]
	screen.model = json["model"]
	screen.available_roles = json["roles_allowed"]
	screen.available_persons = json["persons_allowed"]
	screen.created_at = json["created_at"]
	return screen

static func create_from_response(response: HTTPResponse) -> Array[Screen]:
	var result: Array[Screen]
	if response.content is Array:
		for person_line in response.content:
			result.append(Screen.create_from_json(person_line))
	elif response.content != null:
		result.append(Screen.create_from_json(response.content))
	return result
