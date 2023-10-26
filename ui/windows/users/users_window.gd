class_name UsersWindow
extends Control

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: UsersTable = %"Users Table" as UsersTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add(user: UserData) -> void:
	table.add_user(user)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Users)
