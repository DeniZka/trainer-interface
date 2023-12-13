class_name RestartMenu
extends Control

signal saved(data: Save)
signal deleted(data: Save)
signal closed()

@onready var close_button: Button = %"Close Button" as Button
@onready var load_button: Button = %"Load Button" as Button
@onready var control: MenuBottomControl = %"Menu Buttom Control" as MenuBottomControl

@onready var restart_name_edit: LineEdit = %Name as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit

@onready var uploaded_filename: Label = %"Loaded Filename" as Label
@onready var file_uploader: FileUploader = %"File Uploader" as FileUploader

func _ready() -> void:
	control.saved_pressed.connect(_on_save_button_pressed)
	control.delete_pressed.connect(_on_delete_button_pressed)
	control.cancel_pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)
	file_uploader.uploaded.connect(_on_file_uploaded)

func _on_save_button_pressed() -> void:
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_load_button_pressed() -> void:
	file_uploader.open()

func _on_close_button_pressed() -> void:
	closed.emit()

func _on_file_uploaded(file_name: String, file_type: String, base64_data: String) -> void:
	uploaded_filename.text = file_name
