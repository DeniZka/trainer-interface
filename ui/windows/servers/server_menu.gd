class_name ServerMenu
extends BaseMenu

@onready var name_edit: LineEdit = %"Name" as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit
@onready var data_exchange_edit: LineEdit = %"Data Exchange" as LineEdit

@onready var models_selector: MenuItemsSelector = %"Models Selector" as MenuItemsSelector
@onready var roles_selector: MenuItemsSelector = %"Roles Selector" as MenuItemsSelector
@onready var persons_selector: MenuItemsSelector = %"Persons Selector" as MenuItemsSelector

@onready var initialization_button: Button = %"Inizialization Button" as Button
@onready var play_button: Button = %"Play Button" as Button
@onready var step_button: Button = %"Step Button" as Button
@onready var pause_button: Button = %"Pause Button" as Button
@onready var stop_button: Button = %"Stop Button" as Button

var models: JSONApi
var persons: JSONApi
var roles: JSONApi

func _on_ready() -> void:
	api = Api.servers
	models = Api.models
	persons = Api.persons
	roles = Api.roles

func _on_update_view(data: Server) -> void:
	if data != null:
		name_edit.text = data.name
		author_edit.text = data.author
		upload_date_edit.text = data.created_at
		_show_controls()
	else:
		_hide_controls()
	await _load_and_apply_models(data)
	await _load_and_apply_roles(data)
	await _load_and_apply_persons(data)

func _load_and_apply_models(data: Server) -> void:
	var response: HTTPResponse = await models.all()
	var all_models: Array[Model] = Model.create_from_response(response)
	
	for m in all_models:
		models_selector.append(m.id, m.name)
		if data != null && data.model == m.name:
			models_selector.select([m.id])

func _load_and_apply_roles(data: Server) -> void:
	var response: HTTPResponse = await roles.all()
	var all_roles: Array[PersonRole] = PersonRole.create_from_response(response)
	
	var selected_roles: Array[int]
	for role in all_roles:
		roles_selector.append(role.id, role.name)
		if data != null && data.available_roles.has(role.name):
			selected_roles.append(role.id)
	roles_selector.select(selected_roles)

func _load_and_apply_persons(data: Server) -> void:
	var response: HTTPResponse = await persons.all()
	var all_persons: Array[Person] = Person.create_from_response(response)
	
	var selected_person: Array[int]
	for p in all_persons:
		persons_selector.append(p.id, p.full_name)
		if data != null && data.available_persons.has(p.full_name):
			selected_person.append(p.id)
	persons_selector.select(selected_person)

func _create_from_menu() -> Server:
	var server = Server.new()
	server.name = name_edit.text
	server.author = author_edit.text
	server.created_at = upload_date_edit.text
	for selected_item in models_selector.selected_lines.values():
		server.model = selected_item
	for selected_role in roles_selector.selected_lines.values():
		server.available_roles.append(selected_role)
	for selected_person in persons_selector.selected_lines.values():
		server.available_persons.append(selected_person)
	
	## TODO: create server on backend
	RPC.crete_server.rpc(server.name, server.model)
	
	return server

func _on_clear_view() -> void:
	name_edit.text = ""
	author_edit.text = ""
	upload_date_edit.text = ""
	models_selector.clear()
	persons_selector.clear()
	roles_selector.clear()

func _hide_controls() -> void:
	initialization_button.hide()
	play_button.hide()
	step_button.hide()
	pause_button.hide()
	stop_button.hide()

func _show_controls() -> void:
	initialization_button.show()
	play_button.show()
	step_button.show()
	pause_button.show()
	stop_button.show()
