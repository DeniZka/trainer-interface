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
	var serialized_roles: Array[Dictionary]
	
	for role in roles:
		serialized_roles.append(role.serialize())
	
	return {
		"person_id": id,
		"avatar_id": avatar_id,
		"login": login,
		"password": password,
		"full_name": full_name,
		"locked": locked,
		"roles": serialized_roles
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

static func create_from_response(response: HTTPResponse) -> Array[Person]:
	var result: Array[Person]
	if response.content is Array:
		for person_line in response.content:
			result.append(Person.create_from_json(person_line))
	elif response.content != null:
		result.append(Person.create_from_json(response.content))
	return result

static func create_from_json(json: Dictionary) -> Person:
	var person: Person = Person.new()
	#json = json["Person"]
	person.id = json["person_id"]
	
	if json.has("id"):
		person.id = json["id"]
	
	person.login = json["login"]
	person.password = json["password"]
	person.full_name = json["full_name"]
	#person.locked = json["locked"]
	
	for role_line in json["roles"]:
		person.roles.append(PersonRole.create_from_json(role_line))

	return person
