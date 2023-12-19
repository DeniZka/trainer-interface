class_name ModelMenu
extends BaseMenu

@onready var load_button: Button = %"Load Button" as Button

@onready var model_name_edit: LineEdit = %"Model Name" as LineEdit
@onready var checksum_edit: LineEdit = %Checksum as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit

@onready var file_uploaded: FileUploader = %"File Uploader" as FileUploader
@onready var file_name_label: Label = %"Loaded Filename" as Label

func _on_ready() -> void:
	api = Api.models
	load_button.pressed.connect(_on_load_button_pressed)
	file_uploaded.uploaded.connect(_on_file_uploaded)

func _on_load_button_pressed() -> void:
	file_uploaded.open()

func _on_file_uploaded(file_name: String, file_type: String, base64_data: String) -> void:
	file_name_label.text = file_name
	DatabaseFiles.save(str(data.id), base64_data)

func _on_update_view(data: Model) -> void:
	if data == null:
		load_button.hide()
		return
	
	load_button.show()
	model_name_edit.text = data.name
	author_edit.text = data.author
	checksum_edit.text = str(data.id)
	upload_date_edit.text = data.created_at

func _on_clear_view() -> void:
	model_name_edit.text = ""
	author_edit.text = ""
	checksum_edit.text = ""
	upload_date_edit.text = ""

func _create_from_menu() -> Model:
	var model: Model = Model.new()
	model.name = model_name_edit.text
	model.created_at = upload_date_edit.text
	model.author = author_edit.text
	return model
