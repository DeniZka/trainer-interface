extends Node

var url: String = "https://192.168.100.105:8000"
var http: HTTPRequest

var persons: PersonsApiService
var roles: RolesApiService
var models: ModelsApiService
var saves: SavesApiService
var scenarios: ScenariosApiService
var screens: ScreensApiService

func _ready() -> void:
	http = HTTPRequest.new()
	http.set_tls_options(TLSOptions.client_unsafe())
	add_child(http)
	initialize_api(url, http)

func initialize_api(url: String, http: HTTPRequest) -> void:
	var http_service: HTTPService = HTTPService.new(http)
	self.persons = PersonsApiService.new(url, http_service)
	self.roles = RolesApiService.new(url, http_service)
	self.models = ModelsApiService.new(url, http_service)
	self.saves = SavesApiService.new(url, http_service)
	self.scenarios = ScenariosApiService.new(url, http_service)
	self.screens = ScreensApiService.new(url, http_service)
