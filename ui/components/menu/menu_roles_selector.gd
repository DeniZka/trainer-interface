class_name MenuRolesSelector
extends Control

@export var roles_container: Control
@export var roles_template: PackedScene
@export var line_menu: LineMenu

var selected_roles: Array[PersonRole]
var shown_roles: Dictionary

func clear() -> void:
	for child in roles_container.get_children():
		child.free()
	shown_roles.clear()
	var first = line_menu.menu_items[0]
	line_menu.menu_items.clear()
	line_menu.menu_items.append(first)

func append(role: PersonRole) -> void:
	var line = roles_template.instantiate() as BaseButton
	line_menu.add_item(line)
	line.text = role.name
	shown_roles[role.id] = line
	line.toggled.connect(func(button_pressed: bool): _on_toggled(role, button_pressed))
	roles_container.add_child(line)

func append_array(roles: Array[PersonRole]) -> void:
	for role in roles:
		append(role)

func unselect_all() -> void:
	for role in shown_roles.keys():
		shown_roles[role].button_pressed = false

func select(role_ids: Array[int]) -> void:
	unselect_all()
	for role_id in role_ids:
		shown_roles[role_id].button_pressed = true

func _on_toggled(role: PersonRole, is_selected: bool) -> void:
	if is_selected:
		selected_roles.append(role)
	elif selected_roles.has(role):
		selected_roles.erase(role)
