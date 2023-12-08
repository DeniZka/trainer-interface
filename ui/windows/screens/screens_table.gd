class_name ScreensTable
extends BaseTable

func _on_split_0_sort_children():
	for i in range(container.get_child_count()):
		var row : ScreenRow = container.get_child(i)
		align_row(row)

func align_row(row: ScreenRow) -> void:
	var icon_column = $HBoxContainer/Icon
	var name_column = $HBoxContainer/Split0/Name
	var model_column = $HBoxContainer/Split0/Split1/Connected_model
	var allowed_roles_column = $HBoxContainer/Split0/Split1/Split2/Allowed_roles
	var allowed_users_column = $HBoxContainer/Split0/Split1/Split2/Split3/Allowed_users
	var author = $HBoxContainer/Split0/Split1/Split2/Split3/Split4/Author
	var date = $HBoxContainer/Split0/Split1/Split2/Split3/Split4/Split5/Load_date
	row.align_column_width(icon_column, name_column, model_column, allowed_roles_column, allowed_users_column, author, date)
