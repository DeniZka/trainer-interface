class_name ServersWindow
extends BaseWindow

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: ServersTable = %"Servers Table" as ServersTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func add(server: ServerData) -> void:
	table.add_server(server)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Servers)
