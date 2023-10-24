class_name RoleRow
extends Control

func align_column_width(iconColumnd: Control, nameColumn: Control, rightsColumn: Control):
	var col1 = $Buttons_and_icons
	var col2 = $Split0/Name
	var col3 = $Split0/Split1/Rights
	col1.custom_minimum_size.x = iconColumnd.size.x 
	col2.custom_minimum_size.x = nameColumn.size.x
	col3.custom_minimum_size.x = rightsColumn.size.x

func construct(data: RoleData) -> void:
	%Icon.set_button_icon(load(data.iconPath))
	%Id.set_text(data.id)
	%"Role Name".set_text(data.name)
	%Rights.set_text(data.rights)

func paint_background(color: Color) -> void:
	$Background.color = color
