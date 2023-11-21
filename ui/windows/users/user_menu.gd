class_name UserMenu
extends Control

signal saved(data: UserData)
signal deleted(data: UserData)
signal closed()

@onready var save_button: Button = %"Save Button" as Button
@onready var cancel_button: Button = %"Cancel Button" as Button
@onready var delete_button: Button = %"Delete Button" as Button
@onready var close_button: Button = %"Close Button" as Button

@onready var username_edit: LineEdit = %"Name Edit" as LineEdit
@onready var login_edit: LineEdit = %"Login Edit" as LineEdit
@onready var password_edit: LineEdit = %"Password Edit" as LineEdit

func _ready() -> void:
	save_button.pressed.connect(_on_save_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	cancel_button.pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_save_button_pressed() -> void:
	var user = UserData.new()
	user.name = username_edit.text
	user.login = login_edit.text
	saved.emit(user)

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_close_button_pressed() -> void:
	closed.emit()

