extends Control

@onready var infoTable = $Table/Roles_info_lines

var rolesInfoLine = load("res://Scenes/Info/Lines/Roles_info_line.tscn")

func _on_split_0_sort_children():
	var colIcon = $HBoxContainer/Icon
	var colName = $HBoxContainer/Split0/Name
	var colRights = $HBoxContainer/Split0/Split1/Rights
	for i in range(infoTable.get_child_count()):
		var line : Node = infoTable.get_child(i)
		line.set_column_width(colIcon, colName, colRights)

func add_role_line(buttonPressedCounter):
	var ril = rolesInfoLine.instantiate()
	ril.set_data(buttonPressedCounter)
	infoTable.add_child(ril)
	var colIcon = $HBoxContainer/Icon
	var colName = $HBoxContainer/Split0/Name
	var colRights = $HBoxContainer/Split0/Split1/Rights
	ril.set_column_width(colIcon, colName, colRights)
