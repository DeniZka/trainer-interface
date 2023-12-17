extends Node

## Timeout for http exchange
const TIMEOUT_IN_SECONDS: float = 1.0

var url: String = "https://192.168.100.105:8000"
var http: HTTPRequest

var persons: JSONApi
var roles: JSONApi
var models: JSONApi
var saves: JSONApi
var scenarios: JSONApi
var screens: JSONApi
var servers: JSONApi

func _ready() -> void:
	http = create_http_request(TIMEOUT_IN_SECONDS)
	initialize_api(url, http)

func create_http_request(timeout: float) -> HTTPRequest:
	var request = HTTPRequest.new()
	request.set_tls_options(TLSOptions.client_unsafe())
	request.timeout = timeout
	add_child(request)
	return request

func initialize_api(url: String, http: HTTPRequest) -> void:
	const base_url: String = "http://localhost:3000/"
	var http_service: HTTPService = HTTPService.new(http)
	self.persons = JSONApi.new(base_url + "persons", http_service)
	self.roles = JSONApi.new(base_url + "roles", http_service)
	self.models = JSONApi.new(base_url + "models", http_service)
	self.saves = JSONApi.new(base_url + "saves", http_service)
	self.scenarios = JSONApi.new(base_url + "scenarios", http_service)
	self.screens = JSONApi.new(base_url + "screens", http_service)
	self.servers = JSONApi.new(base_url + "servers", http_service)
