class_name RestartRow
extends BaseRow

var save: Save

func align_column_width(iconColumn: Control, nameColumn: Control, modelColumn: Control, 
		authorColumn: Control, dateColumn: Control):
	$Buttons_and_icons.custom_minimum_size.x = iconColumn.size.x 
	$Split0/Name.custom_minimum_size.x = nameColumn.size.x
	$Split0/Split1/Connected_model.custom_minimum_size.x = modelColumn.size.x
	$Split0/Split1/Split2/Author.custom_minimum_size.x = authorColumn.size.x
	$Split0/Split1/Split2/Split3/Load_date.custom_minimum_size.x = dateColumn.size.x

func construct(data: Save) -> void:
	save = data
	#%Icon.set_button_icon(load(data.iconPath))
	%Id.set_text(data.id)
	%Name.set_text(data.name)
	%"Connected Model Name".set_text(data.model_id)
	%Author.set_text(data.author_id)
	%Date.set_text(data.created_at)

func paint_background(color: Color) -> void:
	$Background.color = color
