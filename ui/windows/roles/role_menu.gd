class_name RoleMenu
extends Control

signal saved(data: PersonRole)
signal deleted(data: PersonRole)
signal closed()

@onready var save_button: Button = %"Save Button" as Button
@onready var cancel_button: Button = %"Cancel Button" as Button
@onready var delete_button: Button = %"Delete Button" as Button
@onready var close_button: Button = %"Close Button" as Button

@onready var rolename_edit: LineEdit = %Rolename as LineEdit

func _ready() -> void:
	save_button.pressed.connect(_on_save_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	cancel_button.pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func open(person: PersonRole) -> void:
	show()

func close() -> void:
	hide()

func _on_save_button_pressed() -> void:
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_close_button_pressed() -> void:
	closed.emit()
