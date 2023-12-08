class_name ServersTable
extends BaseTable

func align_row(row: ServerRow) -> void:
	var icon_column = $HBoxContainer/Icon
	var name_column = $HBoxContainer/Split0/Name
	var model_column = $HBoxContainer/Split0/Split1/Connected_model
	var allowed_roles_column = $HBoxContainer/Split0/Split1/Split2/Allowed_roles
	var allowed_users_column = $HBoxContainer/Split0/Split1/Split2/Split3/Allowed_users
	var author_column = $HBoxContainer/Split0/Split1/Split2/Split3/Split4/Author
	var date_column = $HBoxContainer/Split0/Split1/Split2/Split3/Split4/Split5/Load_date
	var exchange_column = $HBoxContainer/Split0/Split1/Split2/Split3/Split4/Split5/Split6/Data_exchange
	row.align_column_width(icon_column, name_column, model_column, allowed_roles_column, 
		allowed_users_column, author_column, date_column, exchange_column)
