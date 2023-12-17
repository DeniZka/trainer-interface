class_name PersonRole
extends RefCounted

var id: int
var name: String
var overlay_id: String
var rights: Dictionary

func rights_to_string() -> String:
	var line: String = ""
	for key in rights.keys():
		if rights[key]:
			line += key + ", "
	return line

func serialize() -> Dictionary:
	var base: Dictionary = {
		"role_id": id,
		"name": name,
	}
	
	#if overlay_id == "":
	#	base["overlay_id"] = null
	
	#for right in rights.keys():
	#	base[right] = rights[right]
	
	return base

static func take_ids_from(roles: Array[PersonRole]) -> Array[int]:
	var ids: Array[int]
	for role in roles:
		ids.append(role.id)
	return ids

static func create_from_response(response: HTTPResponse) -> Array[PersonRole]:
	var result: Array[PersonRole]
	if response.content is Array:
		for role_line in response.content:
			result.append(create_from_json(role_line))
	else:
		result.append(create_from_response(response.content))
	return result

static func create_from_json(json: Dictionary) -> PersonRole:
	var role: PersonRole = PersonRole.new()
	role.id = json["role_id"]
	role.name = json["name"]
	
	#if json["overlay_id"] != null:
		#role.overlay_id = json["overlay_id"]
	
	#role.rights["person_view"] = json["person_view"]
	#role.rights["person_add"] = json["person_add"]
	#role.rights["role_view"] = json["role_view"]
	#role.rights["role_add"] = json["role_add"]
	return role
