class_name UsersWindow
extends Control

@onready var table: UsersTable = %"Users Table" as UsersTable

func add_user(user: UserData) -> void:
	table.add_user(user)
