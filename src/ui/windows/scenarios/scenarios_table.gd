class_name ScenariosTable
extends BaseTable

func align_row(row: ScenarioRow) -> void:
	var icon_column = $HBoxContainer/Icon
	var name_column = $HBoxContainer/Split0/Name
	var model_column = $HBoxContainer/Split0/Split1/Connected_model
	var author_column = $HBoxContainer/Split0/Split1/Split2/Author
	var upload_date_column = $HBoxContainer/Split0/Split1/Split2/Split3/Load_date
	row.align_column_width(icon_column, name_column, model_column, author_column, upload_date_column)
