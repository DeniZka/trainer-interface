extends Control
class_name UsersInfoLine

var names : Array = [
	"Колымака Василий Фёдорович",
	"Карпенко Пётр Сергеевич",
	"Нечипоренко Константин Александрович",
	"Плаксина Анна Никитична"
]

var logins : Array = [
	"Колымака 4567",
	"Карп 777",
	"Чип 657",
	"Плакса-вакса"
]

var roles : Array = [
	"Ученик",
	"Администратор",
	"Преподаватель, администратор",
	"Ученик"
]

var ids : Array = [
	"00001",
	"00002",
	"00003",
	"00004"
]

var LIGHT_THEME_LIGHT_BLUE = CustomRGBDto.new(0.9372549019607843, 0.9490196078431373, 0.9568627450980392)

func set_column_width(colIcon, colName, colLogin, colRole):
	var col1 = $Buttons_and_icons
	var col2 = $Split0/Name
	var col3 = $Split0/Split1/Login
	var col4 = $Split0/Split1/Split2/Role
	col1.custom_minimum_size.x = colIcon.size.x 
	col2.custom_minimum_size.x = colName.size.x
	col3.custom_minimum_size.x = colLogin.size.x
	col4.custom_minimum_size.x = colRole.size.x



func set_data(buttonPressedCounter):
	var usersInfo = UsersInfoDto.new($Buttons_and_icons/For_icons_and_state/For_icon/Icon, $Split0/Name/Name, $Split0/Split1/Login/Login, $Split0/Split1/Split2/Role/Role, $Buttons_and_icons/For_icons_and_state/ID)
	usersInfo.userIcon.set_button_icon(load("res://Icons/Animals/Orca_62.png")) #add array with icons
	usersInfo.userName.set_text(names[buttonPressedCounter])
	usersInfo.userLogin.set_text(logins[buttonPressedCounter])
	usersInfo.userRole.set_text(roles[buttonPressedCounter])
	usersInfo.userId.set_text("ID: " + ids[buttonPressedCounter])
	if buttonPressedCounter % 2 != 0:
		$Back.color = Color(LIGHT_THEME_LIGHT_BLUE.red, LIGHT_THEME_LIGHT_BLUE.green, LIGHT_THEME_LIGHT_BLUE.blue)
