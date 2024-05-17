class_name ServerRow
extends BaseRow

var data: Server

func align_column_width(icon_column: Control, name_column: Control, model_column: Control, 
		allowed_roles_column: Control, allowed_users_column: Control, author_column: Control, 
		upload_date_column: Control, data_exchange_column: Control):
	$Buttons_and_icons.custom_minimum_size.x = icon_column.size.x
	$Split0/Name.custom_minimum_size.x = name_column.size.x
	$Split0/Split1/Connected_model.custom_minimum_size.x = model_column.size.x
	$Split0/Split1/Split2/Allowed_roles.custom_minimum_size.x = allowed_roles_column.size.x
	$Split0/Split1/Split2/Split3/Allowed_users.custom_minimum_size.x = allowed_users_column.size.x
	$Split0/Split1/Split2/Split3/Split4/Author.custom_minimum_size.x = author_column.size.x
	$Split0/Split1/Split2/Split3/Split4/Split5/Load_date.custom_minimum_size.x = upload_date_column.size.x
	$Split0/Split1/Split2/Split3/Split4/Split5/Split6/Data_exchange.custom_minimum_size.x = data_exchange_column.size.x

func construct(data: Server) -> void:
	self.data = data
	%Id.set_text("ID: %s" % data.id)
	%Name.set_text(data.name)
	%"Connected Model".set_text(data.model)
	%Author.set_text(data.author)
	%"Allowed Roles".set_text(data.available_roles_to_string())
	%"Allowed Users".set_text(data.available_persons_to_string())
	#%Icon.set_button_icon(load(server.icon_path))
	%"Upload Date".set_text(data.created_at)

func paint_background(color: Color) -> void:
	%Background.color = color
