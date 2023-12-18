class_name MenuRolesSelector
extends Control

@export var container: Control
@export var line_menu: LineMenu
@export var line_template: PackedScene

var visible_lines: Dictionary
var selected_lines: Dictionary

var multiple_choice: bool

func clear() -> void:
	for child in container.get_children():
		child.free()
	visible_lines.clear()
	
	if line_menu != null:
		var first = line_menu.menu_items[0]
		line_menu.menu_items.clear()
		line_menu.menu_items.append(first)

func append(item_id: int, description: String) -> void:
	var instance = line_template.instantiate() as BaseButton
	if line_menu != null:
		line_menu.add_item(instance)
	instance.text = description
	visible_lines[item_id] = instance
	instance.toggled.connect(func(pressed: bool): _on_item_toggled(item_id, description, pressed))
	container.add_child(instance)

func _on_item_toggled(id: int, description: String, is_selected: bool) -> void:
	if is_selected:
		selected_lines[id] = description
	elif selected_lines.has(id):
		selected_lines.erase(id)

func append_array(items: Array[Dictionary]) -> void:
	for item in items:
		append(item["id"], item["name"])

func unselect_all() -> void:
	for id in visible_lines.keys():
		visible_lines[id].button_pressed = false

func select(ids: Array[int]) -> void:
	unselect_all()
	for id in ids:
		visible_lines[id].button_pressed = true
