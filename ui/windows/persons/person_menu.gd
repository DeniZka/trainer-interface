class_name PersonMenu
extends BaseMenu

@onready var lock_button: Button = %"Lock Button" as BaseButton
@onready var username_edit: LineEdit = %"Name Edit" as LineEdit
@onready var login_edit: LineEdit = %"Login Edit" as LineEdit
@onready var password_edit: LineEdit = %"Password Edit" as LineEdit
@onready var menu_roles: MenuRolesSelector = %"Menu Roles Selector" as MenuRolesSelector

var roles: JSONApi

func _on_ready() -> void:
	api = Api.persons
	roles = Api.roles

func _on_update_view(person: Person) -> void:
	if person == null:
		return
	
	username_edit.text = person.full_name
	login_edit.text = person.login
	password_edit.text = person.password
	lock_button.button_pressed = person.locked
	await _load_roles(person)

func _load_roles(person: Person) -> void:
	var response: HTTPResponse = await roles.all()
	var roles: Array[PersonRole] = PersonRole.create_from_response(response)
	
	menu_roles.clear()
	menu_roles.append_array(roles)
	
	if person != null:
		menu_roles.select(PersonRole.take_ids_from(person.roles))

func _on_clear_view() -> void:
	username_edit.text = ""
	login_edit.text = ""
	password_edit.text = ""
	lock_button.button_pressed = false
	menu_roles.clear()

func _create_from_menu() -> Person:
	var person = Person.new()
	
	if data != null:
		person.id = data.id
	
	person.full_name = username_edit.text
	person.login = login_edit.text
	person.password = password_edit.text
	person.locked = lock_button.button_pressed
	
	for selected_role in menu_roles.selected_roles:
		person.roles.append(selected_role)
	
	return person
