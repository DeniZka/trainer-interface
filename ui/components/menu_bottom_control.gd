class_name MenuBottomControl
extends HBoxContainer

signal saved_pressed()
signal cancel_pressed()
signal delete_pressed()

@onready var save_button: Button = %"Save Button" as Button
@onready var cancel_button: Button = %"Cancel Button" as Button
@onready var delete_button: Button = %"Delete Button" as Button

func _ready() -> void:
	save_button.pressed.connect(func(): saved_pressed.emit())
	cancel_button.pressed.connect(func(): cancel_pressed.emit())
	delete_button.pressed.connect(func(): delete_pressed.emit())
