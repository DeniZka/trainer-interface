class_name ScreensWindow
extends BaseWindow

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: ScreensTable = %"Screens Table" as ScreensTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Screens)
