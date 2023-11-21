class_name UserRow
extends Control

func align_column_width(iconColumn: Control, nameColumn: Control, loginColumn: Control, roleColumn: Control):
	var col1: Control = $Buttons_and_icons
	var col2: Control = $Split0/Name
	var col3: Control = $Split0/Split1/Login
	var col4: Control = $Split0/Split1/Split2/Role
	col1.custom_minimum_size.x = iconColumn.size.x 
	col2.custom_minimum_size.x = nameColumn.size.x
	col3.custom_minimum_size.x = loginColumn.size.x
	col4.custom_minimum_size.x = roleColumn.size.x

func construct(user: UserData) -> void:
	%Id.set_text("ID: %s" % user.id)
	%Name.set_text(user.name)
	%Login.set_text(user.login)
	%Role.set_text(user.role)
	%Icon.set_button_icon(load(user.icon))

func paint_background(color: Color) -> void:
	%Background.color = color
