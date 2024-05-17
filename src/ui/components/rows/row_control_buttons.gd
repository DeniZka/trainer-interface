class_name RowControlButtons
extends VBoxContainer

signal selected()
signal edited()
signal deleted()

@onready var select_button: Button = $"Select"
@onready var edit_button: Button = $"Edit"
@onready var delete_button: Button = $"Delete"

func _ready() -> void:
	select_button.pressed.connect(func(): selected.emit())
	edit_button.pressed.connect(_on_edited)
	delete_button.pressed.connect(func(): deleted.emit())

func _on_edited() -> void:
	edited.emit()
	edit_button.button_pressed = false
