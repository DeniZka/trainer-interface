class_name BaseWindow
extends Control

signal opened_menu(data)

@onready var search_bar: SearchBar = %"Search Bar" as SearchBar
@onready var table: BaseTable = %"Table" as BaseTable

var api: JSONApi

func _ready() -> void:
	table.edited.connect(_on_row_edited)
	table.selected.connect(_on_row_selected)
	table.deleted.connect(_on_row_deleted)
	
	search_bar.add_button_pressed.connect(_on_add_button_pressed)
	_on_initialize()

func _on_initialize() -> void:
	pass

func _on_row_edited(row) -> void:
	pass

func _on_row_selected(row) -> void:
	pass

func _on_row_deleted(row) -> void:
	pass

func _on_add_button_pressed() -> void:
	opened_menu.emit(null)

func open() -> void:
	Log.trace("Открыл окно %s" % name)
	api.updated.connect(_on_update_data)
	_on_update_data()
	show()

func close() -> void:
	Log.trace("Закрыл окно %s" % name)
	hide()
	api.updated.disconnect(_on_update_data)

func _on_update_data() -> void:
	pass
