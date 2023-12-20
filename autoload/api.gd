extends Node

## Timeout for http exchange
const TIMEOUT_IN_SECONDS: float = 1.0

var url: String = "https://192.168.100.105:8000"
var pool: HTTPRequestPool

var persons: JSONApi
var roles: JSONApi
var models: JSONApi
var saves: JSONApi
var scenarios: JSONApi
var screens: JSONApi
var servers: JSONApi

func _ready() -> void:
	pool = create_http_request_pool(TIMEOUT_IN_SECONDS)
	initialize_api(url, pool)

func create_http_request_pool(timeout: float) -> HTTPRequestPool:
	var pool = HTTPRequestPool.new(timeout)
	add_child(pool)
	return pool

func initialize_api(url: String, pool: HTTPRequestPool) -> void:
	const base_url: String = "http://127.0.0.1:3000/"
	var http_service: HTTPService = HTTPService.new(pool)
	self.persons = JSONApi.new(base_url + "persons", http_service)
	self.roles = JSONApi.new(base_url + "roles", http_service)
	self.models = JSONApi.new(base_url + "models", http_service)
	self.saves = JSONApi.new(base_url + "saves", http_service)
	self.scenarios = JSONApi.new(base_url + "scenarios", http_service)
	self.screens = JSONApi.new(base_url + "screens", http_service)
	self.servers = JSONApi.new(base_url + "servers", http_service)
