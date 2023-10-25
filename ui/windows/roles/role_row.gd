class_name RoleRow
extends Control

func align_column_width(iconColumn: Control, nameColumn: Control, rightsColumn: Control):
	$Buttons_and_icons.custom_minimum_size.x = iconColumn.size.x 
	$Split0/Name.custom_minimum_size.x = nameColumn.size.x
	$Split0/Split1/Rights.custom_minimum_size.x = rightsColumn.size.x

func construct(data: RoleData) -> void:
	%Icon.set_button_icon(load(data.iconPath))
	%Id.set_text(data.id)
	%"Role Name".set_text(data.name)
	%Rights.set_text(data.rights)

func paint_background(color: Color) -> void:
	$Background.color = color
