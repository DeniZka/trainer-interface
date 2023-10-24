class_name UsersWindow
extends Control

signal opened_add_user_menu()

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: UsersTable = %"Users Table" as UsersTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add_user(user: UserData) -> void:
	table.add_user(user)

func _on_add_button_pressed() -> void:
	opened_add_user_menu.emit()
