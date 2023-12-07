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

var updated_person: Person
var persons: PersonsService

func _ready() -> void:
	persons = Services.persons
	save_button.pressed.connect(_on_save_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	cancel_button.pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_save_button_pressed() -> void:
	var person = _create_user_from_settings()
	if person.id == 0:
		persons.add(person)
	else:
		persons.update(person)

func open(person: Person) -> void:
	updated_person = person
	_update_view(updated_person)
	show()
	await _load_roles(updated_person)

func close() -> void:
	hide()
	_clear_view()

func _load_roles(person: Person) -> void:
	var roles = await Api.roles.get_roles(1, 25)
	menu_roles.clear()
	menu_roles.append_array(roles)
	
	if person != null:
		menu_roles.select(person.role_ids)

func _update_view(person: Person) -> void:
	if person == null:
		return
	
	username_edit.text = person.full_name
	login_edit.text = person.login
	password_edit.text = person.password
	lock_button.button_pressed = person.locked

func _clear_view() -> void:
	username_edit.text = ""
	login_edit.text = ""
	password_edit.text = ""
	lock_button.button_pressed = false
	menu_roles.clear()

func _on_delete_button_pressed() -> void:
	closed.emit()
	
	if updated_person != null:
		persons.delete(updated_person)

func _on_close_button_pressed() -> void:
	closed.emit()

func _create_user_from_settings() -> Person:
	var person = Person.new()
	
	if updated_person != null:
		person.id = updated_person.id
	
	person.full_name = username_edit.text
	person.login = login_edit.text
	person.password = password_edit.text
	person.locked = lock_button.button_pressed
	
	for role in menu_roles.selected_roles:
		person.role_ids.append(role.id)
	return person
