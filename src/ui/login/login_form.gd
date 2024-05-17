class_name LoginForm
extends Control

signal authorized(person: Person)

@onready var login_line: LineEdit = %Login 
@onready var password_line: LineEdit = %Password
@onready var enter_button: Button = %"Enter Button"
@onready var invalid_message: Label = %"Invalid Password Message"

var persons: JSONApi

func _ready() -> void:
	persons = Api.persons
	enter_button.pressed.connect(_on_enter_pressed)
	_clear_form()

func _on_enter_pressed() -> void:
	var response: HTTPResponse = await persons.all()
	var all_persons: Array[Person] = Person.create_from_response(response)
	var person = _find_by_login(login_line.text, all_persons)
	
	if person == null || person.password != password_line.text:
		_notify_invalid_login_or_password()
	else:
		authorized.emit(person)
		_clear_form()

func _clear_form() -> void:
	invalid_message.hide()
	login_line.text = ""
	password_line.text = ""

func _notify_invalid_login_or_password() -> void:
	invalid_message.show()

func _find_by_login(login: String, array: Array[Person]) -> Person:
	for person in array:
		if person.login == login:
			return person
	return null
