extends Control

@onready var CONNECT_LINES : Dictionary = {
	"H_Search" : [$Panel/HBoxContainer/SearchPlace/hSearch],
	"V_Search" : [$Panel/HBoxContainer/SearchPlace/vSearch]
}

@onready var BUTTONS : Dictionary = {
	"Search" : $Panel/HBoxContainer/SearchPlace
}

@onready var LINE_EDIT_ARRAY : Array = [
	ButtonDto.new("Search", "V_Search", "H_Search")
]

@onready var upperMenuService: UpperMenuService = UpperMenuService.new(CONNECT_LINES, BUTTONS)

func _on_line_edit_focus_entered():
	upperMenuService.paintUpperMenuFocusEnteredButton(LINE_EDIT_ARRAY[0])

func _on_line_edit_focus_exited():
	upperMenuService.paintUpperMenuFocusExitedButton(LINE_EDIT_ARRAY[0])


