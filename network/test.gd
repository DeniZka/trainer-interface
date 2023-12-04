extends Node

var http: HTTPRequest
var http_service: HTTPService
var persons: PersonService

func _ready() -> void:
	http = HTTPRequest.new()
	http.set_tls_options(TLSOptions.client_unsafe())
	add_child(http)
	
	http_service = HTTPService.new(http)
	persons = PersonService.new("https://192.168.100.105:8000", http_service)
	
	var all_persons = await persons.get_persons(1, 20)
	for person in all_persons:
		print(person)
	
	var result = await persons.delete_person(25)
	print(result.is_not_found())
