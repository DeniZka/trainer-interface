extends Node

@onready var simintech_client: SimintechClient = $RabbitMqClient as SimintechClient
@onready var read_button: Button = $ReadButton
@onready var write_button: Button = $WriteButton

@onready var http: HTTPRequest = $HTTPRequest as HTTPRequest
@onready var file_uploader: FileUploader = $"File Uploader" as FileUploader

const PROJECT_ID: String = "sit_project_1b"

var signals: Array[String] = ["test_0_a", "test_0_b", 
	"test_0_c", "test_0_d", "test_0_bool", "test_0_int"]

var signals_values: Dictionary = { "test_0_a": 0.11, "test_0_b": 1.2, 
	"test_0_c": 2.231, "test_0_d": 3.342, "test_0_bool": true, "test_0_int": 5 }

func _ready() -> void:
	var http: HTTPService = HTTPService.new(Api.http)
	var person_api: JSONApi = JSONApi.new("http://localhost:3000/persons", http)
	var response: HTTPResponse = await person_api.all()
	var persons: Array[Person]
	for person_line in response.content:
		persons.append(Person.create_from_json(person_line))
	
	print(persons)

func _on_file_uploaded(file_name: String, file_type: String, file_base64: String) -> void:
	const URL: String = "https://192.168.100.105:8000/debug/test"
	const FIELD_NAME: String = "test_file"
	var data: FormData = _create_test_form_data()
	data.add_file(FIELD_NAME, file_name, file_type, file_base64)
	print(data.body_as_string())
	
	http.set_tls_options(TLSOptions.client_unsafe())
	http.request(URL, data.headers, HTTPClient.METHOD_POST, data.body_as_string())
	var response = await http.request_completed
	var body: PackedByteArray = response[3]
	print(response)
	print(body.get_string_from_ascii())

func _create_test_form_data() -> FormData:
	var data: FormData = FormData.new()
	data.add_text("test_int", str(25))
	data.add_text("test_str", "zalupa")
	return data

func _on_read_button_pressed() -> void:
	simintech_client.read_signals(0, PROJECT_ID, signals)

func _on_write_button_pressed() -> void:
	simintech_client.write_signals(0, PROJECT_ID, signals_values)

func upload_file(model_id: int, service: ModelsApiService, file_base64: String) -> void:
	var response = await service.upload_file(model_id, "model_file", "application/zip", file_base64)
	print(response)
