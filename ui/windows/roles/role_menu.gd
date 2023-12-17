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

var updated_role: PersonRole

var roles: JSONApi

func _ready() -> void:
	roles = Api.roles
	save_button.pressed.connect(_on_save_button_pressed)
	delete_button.pressed.connect(_on_delete_button_pressed)
	cancel_button.pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func open(person: PersonRole) -> void:
	show()
	updated_role = person
	
	if person != null:
		rolename_edit.text = person.name

func close() -> void:
	hide()

func _on_save_button_pressed() -> void:
	var new_role: PersonRole = _create_person_role()
	if updated_role != null:
		roles.update(updated_role.id, new_role.serialize())
	else:
		roles.create(new_role.serialize())

func _on_delete_button_pressed() -> void:
	deleted.emit(updated_role)

func _on_close_button_pressed() -> void:
	closed.emit()

func _create_person_role() -> PersonRole:
	var role: PersonRole = PersonRole.new()
	role.name = rolename_edit.text
	return role
