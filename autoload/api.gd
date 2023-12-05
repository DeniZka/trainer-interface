extends Node

var url: String = "https://192.168.100.105:8000"
var http: HTTPRequest

var persons: PersonService
var roles: RolesService

func _ready() -> void:
	http = HTTPRequest.new()
	http.set_tls_options(TLSOptions.client_unsafe())
	add_child(http)
	initialize_api(url, http)

func initialize_api(url: String, http: HTTPRequest) -> void:
	var http_service: HTTPService = HTTPService.new(http)
	self.persons = PersonService.new(url, http_service)
	self.roles = RolesService.new(url, http_service)
