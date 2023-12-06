class_name PersonMenu
extends Control

signal saved(data: Person)
signal deleted(data: Person)
signal closed()

@onready var save_button: Button = %"Save Button" as Button
@onready var cancel_button: Button = %"Cancel Button" as Button
@onready var delete_button: Button = %"Delete Button" as Button
@onready var close_button: Button = %"Close Button" as Button
@onready var lock_button: Button = %"Lock Button" as BaseButton

@onready var username_edit: LineEdit = %"Name Edit" as LineEdit
@onready var login_edit: LineEdit = %"Login Edit" as LineEdit
@onready var password_edit: LineEdit = %"Password Edit" as LineEdit

@onready var menu_roles: MenuRolesSelector = %"Menu Roles Selector" as MenuRolesSelector

func _ready() -> void:
	save_button.pressed.connect(_on_save_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	cancel_button.pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_save_button_pressed() -> void:
	var person = _create_user_from_settings()
	PersonProvider.add(person)
	#saved.emit(person)

func open() -> void:
	show()
	var roles = await Api.roles.get_roles(1, 25)
	menu_roles.clear()
	menu_roles.append_array(roles)
	pass

func close() -> void:
	hide()
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_close_button_pressed() -> void:
	closed.emit()

func _create_user_from_settings() -> Person:
	var person = Person.new()
	person.full_name = username_edit.text
	person.login = login_edit.text
	person.password = password_edit.text
	person.locked = lock_button.button_pressed
	
	for role in menu_roles.selected_roles:
		person.role_ids.append(role.id)
	return person
