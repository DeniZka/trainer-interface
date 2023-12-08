class_name ModelsWindow
extends BaseWindow

signal opened_menu(tag: String)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: ModelsTable = %"Models Table" as ModelsTable

func _ready() -> void:
	search_bar.add_button_pressed.connect(_on_add_button_pressed)

func open() -> void:
	super.open()

func close() -> void:
	super.close()

func add(role: ModelData) -> void:
	table.add_model(role)

func _on_add_button_pressed() -> void:
	opened_menu.emit(WindowId.Models)
