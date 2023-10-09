extends Control

@onready var infoTable = $Table/Users_info_lines

var usersInfoLine = load("res://Scenes/Info/Lines/Users_info_line.tscn")

func _on_split_0_sort_children():
	var colIcon = $HBoxContainer/Icon
	var colName = $HBoxContainer/Split0/Name
	var colLogin = $HBoxContainer/Split0/Split1/Login
	var colRole = $HBoxContainer/Split0/Split1/Split2/Role
	for i in range(infoTable.get_child_count()):
		var line : Node = infoTable.get_child(i)
		line.set_column_width(colIcon, colName, colLogin, colRole)

func add_line(buttonPressedCounter):
	var uil = usersInfoLine.instantiate()
	uil.set_data(buttonPressedCounter)
	infoTable.add_child(uil)
	var colIcon = $HBoxContainer/Icon
	var colName = $HBoxContainer/Split0/Name
	var colLogin = $HBoxContainer/Split0/Split1/Login
	var colRole = $HBoxContainer/Split0/Split1/Split2/Role
	uil.set_column_width(colIcon, colName, colLogin, colRole)
