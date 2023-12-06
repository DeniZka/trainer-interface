class_name PersonsApiService
extends RefCounted

var url: String
var http: HTTPService

func _init(url: String, http: HTTPService) -> void:
	self.url = url + "/persons"
	self.http = http

## Get all users from database
func get_persons(page: int, size: int) -> Array[Person]:
	var endpoint: String = Url.with_parameters(url, { "page": page, "size": size })
	var response = await http.send_get(endpoint);
	
	if not response.is_success():
		return []
	
	return _parse_persons_from_json(response.content["items"])

## Update person with new person and return new person from database
func update_person(person_id: int, new_person: Person) -> Person:
	var serialized_person = new_person.serialize()
	serialized_person.erase("person_id")
	serialized_person.erase("role_ids")
	var endpoint: String = Url.with_parameters(url + "/" + str(person_id) +"/", serialized_person)
	var response = await http.send_patch(endpoint);
	
	if not response.is_success():
		return null
	
	return Person.create_from_json(response.content);

## Create new user from user data, return new user Id
func create_person(user: Person) -> Person:
	var serialized_person = user.serialize(false)
	serialized_person.erase("role_ids")
	var endpoint: String = Url.with_parameters(url, serialized_person)
	var response = await http.send_post(endpoint);
	
	if not response.is_success():
		return null
	
	return Person.create_from_json(response.content);

## Delete person, return status code (200 - OK, 404 - NOT FOUND, etc) when success
func delete_person(person_id: int) -> HTTPResponse:
	var endpoint = url + "/persons/" + str(person_id)
	var response = await http.send_delete(endpoint)
	return response

func _parse_persons_from_json(json_data: Array) -> Array[Person]:
	var answer: Array[Person]
	for data in json_data:
		answer.append(Person.create_from_json(data))
	return answer
