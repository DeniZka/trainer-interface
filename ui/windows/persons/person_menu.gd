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
var roles_api: JSONApi
var persons_api: JSONApi

func _ready() -> void:
	roles_api = Api.roles
	persons_api = Api.persons
	
	save_button.pressed.connect(_on_save_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	cancel_button.pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_save_button_pressed() -> void:
	var person = _create_user_from_settings()
	if person.id == 0:
		persons_api.create(person.serialize())
	else:
		persons_api.update(person.id, person.serialize())

func open(person: Person) -> void:
	updated_person = person
	_update_view(updated_person)
	show()
	await _load_roles(updated_person)

func close() -> void:
	hide()
	_clear_view()

func _load_roles(person: Person) -> void:
	var respones: HTTPResponse = await roles_api.all()
	var roles: Array[PersonRole]
	for role_json in respones.content:
		roles.append(PersonRole.create_from_json(role_json))
	
	menu_roles.clear()
	menu_roles.append_array(roles)
	
	if person != null:
		var role_ids: Array[int]
		for role in person.roles:
			role_ids.append(role.id)
		menu_roles.select(role_ids)

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
		persons_api.delete(updated_person.id)

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
	
	for selected_role in menu_roles.selected_roles:
		person.roles.append(selected_role)
	
	return person
