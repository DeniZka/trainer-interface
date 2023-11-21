class_name LoginForm
extends Control

@onready var login_line: LineEdit = %Login 
@onready var password_line: LineEdit = %Password
@onready var enter_button: Button = %"Enter Button"

func _ready() -> void:
	enter_button.pressed.connect(_on_enter_pressed)

func _on_enter_pressed() -> void:
	visible = false
