class_name ModelMenu
extends Control

signal saved(data: ModelData)
signal deleted(data: ModelData)
signal closed()

@onready var close_button: Button = %"Close Button" as Button
@onready var load_button: Button = %"Load Button" as Button
@onready var control: MenuBottomControl = %"Menu Buttom Control Row" as MenuBottomControl

@onready var model_name_edit: LineEdit = %"Model Name" as LineEdit
@onready var checksum_edit: LineEdit = %Checksum as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit

func _ready() -> void:
	control.saved_pressed.connect(_on_save_button_pressed)
	control.delete_pressed.connect(_on_delete_button_pressed)
	control.cancel_pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)

func _on_save_button_pressed() -> void:
	var model = ModelData.new()
	model.name = model_name_edit.text
	model.checksum = checksum_edit.text
	model.author = author_edit.text
	model.upload_at = upload_date_edit.text
	saved.emit(model)

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_load_button_pressed() -> void:
	pass

func _on_close_button_pressed() -> void:
	closed.emit()
