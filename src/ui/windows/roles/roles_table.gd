class_name RolesTable
extends BaseTable

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : RoleRow = container.get_child(i)
		align_row(row)

func align_row(row: RoleRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var rightsColumn = $HBoxContainer/Split0/Split1/Rights
	row.align_column_width(iconColumn, nameColumn, rightsColumn)
