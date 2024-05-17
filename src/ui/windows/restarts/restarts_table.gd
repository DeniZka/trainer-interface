class_name RestartsTable
extends BaseTable

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : RestartRow = container.get_child(i)
		align_row(row)

func align_row(row: RestartRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var modelColumn = $HBoxContainer/Split0/Split1/Connected_model
	var authorColumn = $HBoxContainer/Split0/Split1/Split2/Author
	var dateColumnt = $HBoxContainer/Split0/Split1/Split2/Split3/Load_date
	row.align_column_width(iconColumn, nameColumn, modelColumn, authorColumn, dateColumnt)
