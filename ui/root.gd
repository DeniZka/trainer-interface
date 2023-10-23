class_name Root
extends Control

@onready var button: Button = $Button as Button
@onready var users: UsersWindow = $"Content/Users Window" as UsersWindow

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

var icon: String = "res://Icons/Animals/Orca_62.png"

var button_pressed_count: int = 0

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	button_pressed_count += 1
	
	if button_pressed_count == 4:
		button_pressed_count = 0
	
	users.add_user(_create_test_user(button_pressed_count))

func _create_test_user(index: int) -> UserData:
	var user: UserData = UserData.new()
	user.id = ids[index]
	user.name = names[index]
	user.login = logins[index]
	user.role = roles[index]
	user.icon = icon
	return user
