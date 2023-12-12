extends Node

@onready var dialog: FileDialog = $FileDialog as FileDialog
@onready var simintech_client: SimintechClient = $RabbitMqClient as SimintechClient
@onready var read_button: Button = $ReadButton
@onready var write_button: Button = $WriteButton

const PROJECT_ID: String = "sit_project_1b"

var signals: Array[String] = ["test_0_a", "test_0_b", 
	"test_0_c", "test_0_d", "test_0_bool", "test_0_int"]

var signals_values: Dictionary = { "test_0_a": 0.11, "test_0_b": 1.2, 
	"test_0_c": 2.231, "test_0_d": 3.342, "test_0_bool": true, "test_0_int": 5 }

func _ready() -> void:
	await simintech_client.initialize()
	read_button.pressed.connect(_on_read_button_pressed)
	write_button.pressed.connect(_on_write_button_pressed)

func _on_read_button_pressed() -> void:
	simintech_client.read_signals(0, PROJECT_ID, signals)

func _on_write_button_pressed() -> void:
	simintech_client.write_signals(0, PROJECT_ID, signals_values)

func _on_file_selected(path: String) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var data = file.get_buffer(file.get_length())
	print(data)
	var base64 = Marshalls.raw_to_base64(data)
	file.close()
	#await upload_file(1, Api.models, base64)

func upload_file(model_id: int, service: ModelsApiService, file_base64: String) -> void:
	var response = await service.upload_file(model_id, "model_file", "application/zip", file_base64)
	print(response)
