class_name ScreenRow
extends BaseRow

var data: Screen

func align_column_width(iconColumn: Control, nameColumn: Control, modelColumn: Control, allowedRolesColumn: Control,
		allowerdAuthorsColumn: Control, authorColumn: Control, dateColumn: Control):
	$Buttons_and_icons.custom_minimum_size.x = iconColumn.size.x 
	$Split0/Name.custom_minimum_size.x = nameColumn.size.x
	$Split0/Split1/Connected_model.custom_minimum_size.x = modelColumn.size.x
	$Split0/Split1/Split2/Allowed_roles.custom_minimum_size.x = allowedRolesColumn.size.x
	$Split0/Split1/Split2/Split3/Allowed_users.custom_minimum_size.x = allowerdAuthorsColumn.size.x
	$Split0/Split1/Split2/Split3/Split4/Author.custom_minimum_size.x = authorColumn.size.x
	$Split0/Split1/Split2/Split3/Split4/Split5/Load_date.custom_minimum_size.x = dateColumn.size.x

func construct(data: Screen) -> void:
	self.data = data
	%Id.set_text("ID: %s" % data.id)
	#%Icon.set_button_icon(load(data.icon_path))
	%Name.set_text(data.name)
	%"Connected Model".set_text(data.model)
	%"Allowed Roles".set_text(data.available_roles_to_string())
	%"Allowed Users".set_text(data.available_persons_to_string())
	%Author.set_text(data.author)
	%Date.set_text(data.created_at)

func paint_background(color: Color) -> void:
	$Background.color = color
