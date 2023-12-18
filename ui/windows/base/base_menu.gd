class_name BaseMenu
extends Control

signal saved(data)
signal deleted(data)
signal closed()

@onready var close_button: Button = %"Close Button" as Button
@onready var control: MenuBottomControl = %"Menu Buttom Control" as MenuBottomControl

var data
var api: JSONApi

func _ready() -> void:
	control.saved_pressed.connect(_on_save_button_pressed)
	control.delete_pressed.connect(_on_delete_button_pressed)
	control.cancel_pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	_on_ready()

func _on_ready() -> void:
	pass

func open(data) -> void:
	self.data = data
	_on_update_view(data)
	show()

func close() -> void:
	hide()
	_on_clear_view()

func _on_update_view(data) -> void:
	pass

func _on_clear_view() -> void:
	pass

func _on_save_button_pressed() -> void:
	var serialized: Dictionary =  _create_from_menu().serialize()
	
	if data != null:
		api.update(data.id, serialized)
	else:
		api.create(serialized)
	close()

func _create_from_menu():
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(data)
	
	if data != null:
		api.delete(data.id)

func _on_close_button_pressed() -> void:
	closed.emit()
