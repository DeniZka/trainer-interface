class_name ModelRow
extends BaseRow

var model: Model

func align_column_width(iconColumn: Control, nameColumn: Control, checksumColumn: Control, 
		authorColumn: Control, dateColumn: Control):
	$Buttons_and_icons.custom_minimum_size.x = iconColumn.size.x 
	$Split0/Name.custom_minimum_size.x = nameColumn.size.x
	$Split0/Split1/Control_sum.custom_minimum_size.x = checksumColumn.size.x
	$Split0/Split1/Split2/Author.custom_minimum_size.x = authorColumn.size.x
	$Split0/Split1/Split2/Split3/Load_date.custom_minimum_size.x = dateColumn.size.x

func construct(data: Model) -> void:
	model = data
	#%Icon.set_button_icon(load(data.iconPath))
	%Id.set_text("ID: %s" % data.id)
	%Author.set_text(data.author)
	%Name.set_text(data.name)
	#%Checksum.set_text()
	%Date.set_text(data.created_at)

func paint_background(color: Color) -> void:
	$Background.color = color
