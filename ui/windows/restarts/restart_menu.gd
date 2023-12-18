class_name RestartMenu
extends BaseMenu

@onready var load_button: Button = %"Load Button" as Button

@onready var restart_name_edit: LineEdit = %Name as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit

@onready var models_selector: MenuItemsSelector = %"Models Selector" as MenuItemsSelector

@onready var uploaded_filename: Label = %"Loaded Filename" as Label
@onready var file_uploader: FileUploader = %"File Uploader" as FileUploader

func _on_ready() -> void:
	load_button.pressed.connect(_on_load_button_pressed)
	file_uploader.uploaded.connect(_on_file_uploaded)

func _on_load_button_pressed() -> void:
	file_uploader.open()

func _on_file_uploaded(file_name: String, file_type: String, base64_data: String) -> void:
	uploaded_filename.text = file_name
