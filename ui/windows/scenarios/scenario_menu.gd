class_name ScenarioMenu
extends BaseMenu

@onready var load_button: Button = %"Load Button" as Button

@onready var scenario_name_edit: LineEdit = %"Scenario Name" as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit
@onready var models_selector: MenuRolesSelector = %"Models Selector" as MenuRolesSelector

@onready var loaded_filename: Label = %"Loaded Filename" as Label
@onready var file_uploader: FileUploader = %"File Uploader" as FileUploader
 
var models: JSONApi

func _on_ready() -> void:
	models = Api.models
	load_button.pressed.connect(_on_load_button_pressed)
	file_uploader.uploaded.connect(_on_file_uploaded)

func _on_update_view(data: Scenario) -> void:
	if data == null:
		return
	
	scenario_name_edit.text = data.name
	author_edit.text = data.author
	upload_date_edit.text = data.created_at
	await _load_and_apply_models(data)

func _load_and_apply_models(data: Scenario) -> void:
	var response: HTTPResponse = await models.all()
	var all_models: Array[Model] = Model.create_from_response(response)
	
	for m in all_models:
		models_selector.append(m.id, m.name)
		if data.model == m.name:
			models_selector.select([m.id])
	

func _on_clear_view() -> void:
	scenario_name_edit.text = ""
	author_edit.text = ""
	upload_date_edit.text = ""
	models_selector.clear()

func _on_load_button_pressed() -> void:
	file_uploader.open()

func _on_file_uploaded(file_name: String, file_type: String, base64_data: String) -> void:
	loaded_filename.text = file_name
