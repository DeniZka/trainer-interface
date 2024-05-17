class_name ModelsTable
extends BaseTable

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : ModelRow = container.get_child(i)
		align_row(row)

func align_row(row: ModelRow) -> void:
	var iconColumn = $HBoxContainer/Icon
	var nameColumn = $HBoxContainer/Split0/Name
	var checksumColumn = $HBoxContainer/Split0/Split1/Control_sum
	var authorColumn = $HBoxContainer/Split0/Split1/Split2/Author
	var dateColumn = $HBoxContainer/Split0/Split1/Split2/Split3/Load_date
	row.align_column_width(iconColumn, nameColumn, checksumColumn, authorColumn, dateColumn)
