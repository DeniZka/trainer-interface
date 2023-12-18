class_name AuthorizatedWindowsManager
extends Control

@onready var windows_manager: WindowsManager = %"Windows Manager" as WindowsManager
@onready var login_form: LoginForm = %"Login Form" as LoginForm

func _ready() -> void:
	login_form.authorized.connect(_on_person_authorized)
	windows_manager.navigation_bar.logout.connect(_on_person_logout)

func _on_person_authorized(person: Person) -> void:
	windows_manager.navigation_bar.set_person(person)
	login_form.hide()

func _on_person_logout() -> void:
	login_form.show()
