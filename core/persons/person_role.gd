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

static func create_from_json(json: Dictionary) -> PersonRole:
	var role: PersonRole = PersonRole.new()
	role.id = json["role_id"]
	role.name = json["name"]
	if json["overlay_id"] != null:
		role.overlay_id = json["overlay_id"]
	
	role.rights["person_view"] = json["person_view"]
	role.rights["person_add"] = json["person_add"]
	role.rights["role_view"] = json["role_view"]
	role.rights["role_add"] = json["role_add"]
	return role
