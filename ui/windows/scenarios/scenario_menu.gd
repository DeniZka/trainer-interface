class_name ScenarioMenu
extends Control

signal saved(data: Scenario)
signal deleted(data: Scenario)
signal closed()

@onready var close_button: Button = %"Close Button" as Button
@onready var load_button: Button = %"Load Button" as Button
@onready var control: MenuBottomControl = %"Menu Buttom Control" as MenuBottomControl

@onready var scenario_name_edit: LineEdit = %"Scenario Name" as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit

func _ready() -> void:
	control.saved_pressed.connect(_on_save_button_pressed)
	control.delete_pressed.connect(_on_delete_button_pressed)
	control.cancel_pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	load_button.pressed.connect(_on_load_button_pressed)

func _on_save_button_pressed() -> void:
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_load_button_pressed() -> void:
	pass

func _on_close_button_pressed() -> void:
	closed.emit()
