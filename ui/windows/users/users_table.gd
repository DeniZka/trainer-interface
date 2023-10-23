class_name Users_Table
extends Control

@onready var container: Control = %Container
@export var user_row_prefab: PackedScene

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : UserRow = container.get_child(i)
		align_row(row)

func add_user(user: UserData) -> void:
	var user_row: UserRow = user_row_prefab.instantiate() as UserRow
	user_row.construct(user)
	align_row(user_row)

func align_row(row: UserRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var loginColumn = $HBoxContainer/Split0/Split1/Login
	var roleColumn = $HBoxContainer/Split0/Split1/Split2/Role
	row.align_column_width(iconColumn, nameColumn, loginColumn, roleColumn)
