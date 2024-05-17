class_name SearchBar
extends Control

signal add_button_pressed()
signal edit_button_pressed()
signal delete_button_pressed()
signal search_pressed(text: String)

@onready var add_button: Button = %Add as Button
@onready var edit_button: Button = %Edit as Button
@onready var delete_button: Button = %Delete as Button
@onready var search_button: Button = %Search as Button
@onready var search_bar: LineEdit = %SearchPlace as LineEdit

func _ready() -> void:
	add_button.pressed.connect(func(): add_button_pressed.emit())
	edit_button.pressed.connect(func(): edit_button_pressed.emit())
	delete_button.pressed.connect(func(): delete_button_pressed.emit())
	search_button.pressed.connect(func(): search_pressed.emit(search_bar.text))
	search_bar.text_submitted.connect(func(text: String): search_pressed.emit(text))
