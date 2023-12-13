class_name ModelMenu
extends Control

signal saved(data: Model)
signal deleted(data: Model)
signal closed()

@onready var close_button: Button = %"Close Button" as Button
@onready var load_button: Button = %"Load Button" as Button
@onready var control: MenuBottomControl = %"Menu Buttom Control Row" as MenuBottomControl

@onready var model_name_edit: LineEdit = %"Model Name" as LineEdit
@onready var checksum_edit: LineEdit = %Checksum as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit

@onready var file_uploaded: FileUploader = %"File Uploader" as FileUploader
@onready var file_name_label: Label = %"Loaded Filename" as Label

func _ready() -> void:
	control.saved_pressed.connect(_on_save_button_pressed)
	control.delete_pressed.connect(_on_delete_button_pressed)
	control.cancel_pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)
	file_uploaded.uploaded.connect(_on_file_uploaded)

func _on_save_button_pressed() -> void:
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_load_button_pressed() -> void:
	file_uploaded.open()

func _on_close_button_pressed() -> void:
	closed.emit()

func _on_file_uploaded(file_name: String, file_type: String, base64_data: String) -> void:
	file_name_label.text = file_name
