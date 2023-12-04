class_name PersonRole
extends RefCounted

var id: int
var name: String
var overlay_id: String
var person_view: bool
var person_add: bool
var role_view: bool
var role_add: bool

static func create_from_json(json: Dictionary) -> PersonRole:
	var role: PersonRole = PersonRole.new()
	role.id = json["role_id"]
	role.name = json["name"]
	role.overlay_id = json["overlay_id"]
	role.person_view = json["person_view"]
	role.person_add = json["person_add"]
	role.role_view = json["role_view"]
	role.role_add = json["role_add"]
	return role
