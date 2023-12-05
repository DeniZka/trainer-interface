class_name PersonsTable
extends Control

@onready var container: Control = %Container
@export var person_row_prefab: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : PersonRow = container.get_child(i)
		align_row(row)

func add_user(user: Person) -> void:
	var user_row: PersonRow = person_row_prefab.instantiate() as PersonRow
	user_row.construct(user)
	container.add_child(user_row)
	
	if container.get_child_count() % 2 == 0:
		user_row.paint_background(background_color)
	
	align_row(user_row)

func align_row(row: PersonRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var loginColumn = $HBoxContainer/Split0/Split1/Login
	var roleColumn = $HBoxContainer/Split0/Split1/Split2/Role
	row.align_column_width(iconColumn, nameColumn, loginColumn, roleColumn)
