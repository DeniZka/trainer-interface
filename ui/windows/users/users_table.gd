class_name UsersTable
extends Control

@onready var container: Control = %Container
@export var user_row_prefab: PackedScene

var background_color: Color = Color(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : UserRow = container.get_child(i)
		align_row(row)

func add_user(user: UserData) -> void:
	var user_row: UserRow = user_row_prefab.instantiate() as UserRow
	user_row.construct(user)
	container.add_child(user_row)
	
	if container.get_child_count() % 2 == 0:
		user_row.paint_background(background_color)
	
	align_row(user_row)

func align_row(row: UserRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var loginColumn = $HBoxContainer/Split0/Split1/Login
	var roleColumn = $HBoxContainer/Split0/Split1/Split2/Role
	row.align_column_width(iconColumn, nameColumn, loginColumn, roleColumn)
