class_name PersonsTable
extends BaseTable

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : PersonRow = container.get_child(i)
		align_row(row)

func align_row(row: PersonRow) -> void:
	var iconColumn = $Container/HBoxContainer/Icon
	var nameColumn = $Container/HBoxContainer/Split0/Name
	var loginColumn = $Container/HBoxContainer/Split0/Split1/Login
	var roleColumn = $Container/HBoxContainer/Split0/Split1/Split2/Role
	row.align_column_width(iconColumn, nameColumn, loginColumn, roleColumn)
