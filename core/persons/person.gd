class_name Person
extends RefCounted

var id: int
var avatar_id: int
var login: String
var password: String
var full_name: String
var locked: bool
var role_ids: Array[int]
var roles: Array[PersonRole]

func _to_string() -> String:
	return "Person [%s] login: %s; password: %s; full_name: %s; roles: %s. [locked: %s]" % [id, login, password, full_name, _roles_to_string(), locked]

func _roles_to_string() -> String:
	var line: String = ""
	for role in role_ids:
		line += str(role) + ", "
	return line

func serialize(with_id: bool = true) -> Dictionary:
	if with_id:
		return serialize_with_id()
	else:
		return serialize_without_id()

func apply_roles(roles: Array[PersonRole]) -> void:
	self.roles = roles

func roles_to_string() -> String:
	var line: String = ""
	for index in roles.size():
		line += str(roles[index].name)
		if index < roles.size() - 1:
			line += ", "
	return line

func serialize_without_id() -> Dictionary:
	return {
		"avatar_id": avatar_id,
		"login": login,
		"password": password,
		"full_name": full_name,
		"locked": locked,
		"role_ids": role_ids
	}

func serialize_with_id() -> Dictionary:
	return {
		"person_id": id,
		"avatar_id": avatar_id,
		"login": login,
		"password": password,
		"full_name": full_name,
		"locked": locked,
		"role_ids": role_ids
	}

static func create_from_json(json: Dictionary) -> Person:
	var person: Person = Person.new()
	person.id = json["person_id"]
	person.login = json["login"]
	person.password = json["password"]
	person.full_name = json["full_name"]
	person.locked = json["locked"]
	
	if json.has("role_ids"):
		for id in json["role_ids"]:
			if id != null:
				person.role_ids.append(int(id))

	return person