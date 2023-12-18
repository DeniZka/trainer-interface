class_name ScreenMenu
extends BaseMenu

@onready var load_button: Button = %"Load Button" as Button

@onready var screen_name_edit: LineEdit = %"Screen Name" as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit

@onready var models_selector: MenuItemsSelector = %"Models Selector" as MenuItemsSelector
@onready var roles_selector: MenuItemsSelector = %"Roles Selector" as MenuItemsSelector
@onready var persons_selector: MenuItemsSelector = %"Persons Selector" as MenuItemsSelector

@onready var loaded_filename: Label = %"Loaded Filename" as Label
@onready var file_uploader: FileUploader = %"File Uploader" as FileUploader

var models: JSONApi
var persons: JSONApi
var roles: JSONApi

func _on_ready() -> void:
	api = Api.screens
	models = Api.models
	persons = Api.persons
	roles = Api.roles
	
	load_button.pressed.connect(_on_load_button_pressed)
	file_uploader.uploaded.connect(_on_file_uploaded)

func _on_update_view(data: Screen) -> void:
	if data == null:
		return
	
	screen_name_edit.text = data.name
	author_edit.text = data.author
	upload_date_edit.text = data.created_at
	await _load_and_apply_models(data)
	await _load_and_apply_roles(data)
	await _load_and_apply_persons(data)

func _load_and_apply_models(data: Screen) -> void:
	var response: HTTPResponse = await models.all()
	var all_models: Array[Model] = Model.create_from_response(response)
	
	for m in all_models:
		models_selector.append(m.id, m.name)
		if data.model == m.name:
			models_selector.select([m.id])

func _load_and_apply_roles(data: Screen) -> void:
	var response: HTTPResponse = await roles.all()
	var all_roles: Array[PersonRole] = PersonRole.create_from_response(response)
	
	var selected_roles: Array[int]
	for role in all_roles:
		roles_selector.append(role.id, role.name)
		if data.available_roles.has(role.name):
			selected_roles.append(role.id)
	roles_selector.select(selected_roles)

func _load_and_apply_persons(data: Screen) -> void:
	var response: HTTPResponse = await persons.all()
	var all_persons: Array[Person] = Person.create_from_response(response)
	
	var selected_person: Array[int]
	for p in all_persons:
		persons_selector.append(p.id, p.full_name)
		if data.available_persons.has(p.full_name):
			selected_person.append(p.id)
	persons_selector.select(selected_person)

func _create_from_menu() -> Screen:
	var scenario = Screen.new()
	scenario.name = screen_name_edit.text
	scenario.author = author_edit.text
	scenario.created_at = upload_date_edit.text
	for selected_item in models_selector.selected_lines.values():
		scenario.model = selected_item
	for selected_role in roles_selector.selected_lines.values():
		scenario.available_roles.append(selected_role)
	for selected_person in persons_selector.selected_lines.values():
		scenario.available_persons.append(selected_person)
	return scenario

func _on_clear_view() -> void:
	screen_name_edit.text = ""
	author_edit.text = ""
	upload_date_edit.text = ""
	models_selector.clear()
	persons_selector.clear()
	roles_selector.clear()

func _on_load_button_pressed() -> void:
	file_uploader.open()

func _on_file_uploaded(file_name: String, file_type: String, base64_data: String) -> void:
	loaded_filename.text = file_name
