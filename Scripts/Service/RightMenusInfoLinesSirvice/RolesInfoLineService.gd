extends Control
class_name RolesInfoLine

var names : Array = [
	"Ученик",
	"Преподаватель",
	"Администратор"
]

var rights : Array = [
	"Право 11, Право 12, Право 13, Право 14, Право 15",
	"Право 21, Право 22, Право 23, Право 24, Право 25",
	"Право 31, Право 32, Право 33, Право 34, Право 35"
]

var ids : Array = [
	"00001",
	"00002",
	"00003"
]

var LIGHT_THEME_LIGHT_BLUE = CustomRGBDto.new(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func set_column_width(colIcon, colName, colRights):
	var col1 = $Buttons_and_icons
	var col2 = $Split0/Name
	var col3 = $Split0/Split1/Rights
	col1.custom_minimum_size.x = colIcon.size.x 
	col2.custom_minimum_size.x = colName.size.x
	col3.custom_minimum_size.x = colRights.size.x



func set_data(buttonPressedCounter):
	var rolesInfo = RolesInfoDto.new($Buttons_and_icons/For_icons_and_state/For_icon/Icon, $Split0/Name/Name, $Split0/Split1/Rights/Rights, $Buttons_and_icons/For_icons_and_state/ID)
	rolesInfo.roleIcon.set_button_icon(load("res://Icons/Animals/Orca_62.png")) #add array with icons
	rolesInfo.roleName.set_text(names[buttonPressedCounter])
	rolesInfo.roleRights.set_text(rights[buttonPressedCounter])
	rolesInfo.roleId.set_text("ID: " + ids[buttonPressedCounter])
	if buttonPressedCounter % 2 != 0:
		$Back.color = Color(LIGHT_THEME_LIGHT_BLUE.red, LIGHT_THEME_LIGHT_BLUE.green, LIGHT_THEME_LIGHT_BLUE.blue)
