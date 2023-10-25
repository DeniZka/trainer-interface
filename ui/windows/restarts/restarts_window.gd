class_name RestartsWindow
extends Control

signal opened_restart_menu()

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: RestartsTable = %"Restarts Table" as RestartsTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add_restart(restart: RestartData ) -> void:
	table.add_restart(restart)

func _on_add_button_pressed() -> void:
	opened_restart_menu.emit()
