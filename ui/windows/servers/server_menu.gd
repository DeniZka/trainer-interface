class_name ServerMenu
extends Control

signal saved(data: Server)
signal deleted(data: Server)
signal closed()

@onready var close_button: Button = %"Close Button" as Button
@onready var control: MenuBottomControl = %"Menu Buttom Control" as MenuBottomControl

@onready var name_edit: LineEdit = %"Name" as LineEdit
@onready var author_edit: LineEdit = %Author as LineEdit
@onready var upload_date_edit: LineEdit = %"Upload Date" as LineEdit
@onready var data_exchange_edit: LineEdit = %"Data Exchange" as LineEdit

func _ready() -> void:
	control.saved_pressed.connect(_on_save_button_pressed)
	control.delete_pressed.connect(_on_delete_button_pressed)
	control.cancel_pressed.connect(_on_close_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_save_button_pressed() -> void:
	pass

func _on_delete_button_pressed() -> void:
	deleted.emit(null)

func _on_close_button_pressed() -> void:
	closed.emit()
