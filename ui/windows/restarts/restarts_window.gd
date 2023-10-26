class_name RestartsWindow
extends Control

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: RestartsTable = %"Restarts Table" as RestartsTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add(restart: RestartData ) -> void:
	table.add_restart(restart)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Restarts)
