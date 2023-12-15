class_name Person
extends RefCounted

var id: int
var avatar_id: int
var login: String
var password: String
var full_name: String
var locked: bool
var roles: Array[PersonRole]

func _to_string() -> String:
	return "Person [%s] login: %s; password: %s; full_name: %s; roles: %s. [locked: %s]" % [id, login, password, full_name, _roles_to_string(), locked]

func _roles_to_string() -> String:
	var line: String = ""
	for role in roles:
		line += str(role) + ", "
	return line

func serialize(with_id: bool = true) -> Dictionary:
	return {
		"person_id": id,
		"avatar_id": avatar_id,
		"locked": locked,
		"login": login,
		"password": password,
		"full_name": full_name,
		#"roles": roles
#		"role_ids": role_ids
	}

func apply_roles(roles: Array[PersonRole]) -> void:
	self.roles = roles

func roles_to_string() -> String:
	var line: String = ""
	for index in roles.size():
		line += str(roles[index].name)
		if index < roles.size() - 1:
			line += ", "
	return line

static func create_from_json(json: Dictionary) -> Person:
	var person: Person = Person.new()
	person.id = json["person_id"]
	person.login = json["login"]
	person.password = json["password"]
	person.full_name = json["full_name"]
	person.locked = json["locked"]
	
	for role_line in json["roles"]:
		person.roles.append(PersonRole.create_from_json(role_line))

	return person
