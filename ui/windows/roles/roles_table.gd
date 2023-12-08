class_name RolesTable
extends Control

@onready var container: Control = %Container
@export var role_row_template: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : RoleRow = container.get_child(i)
		align_row(row)

func clear() -> void:
	for child in container.get_children():
		child.free()

func add_array(roles: Array[PersonRole]) -> void:
	for role in roles:
		add(role)

func add(role: PersonRole) -> void:
	var role_row: RoleRow = role_row_template.instantiate() as RoleRow
	role_row.construct(role)
	container.add_child(role_row)
	
	if container.get_child_count() % 2 == 0:
		role_row.paint_background(background_color)
	
	align_row(role_row)

func align_row(row: RoleRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var rightsColumn = $HBoxContainer/Split0/Split1/Rights
	row.align_column_width(iconColumn, nameColumn, rightsColumn)
