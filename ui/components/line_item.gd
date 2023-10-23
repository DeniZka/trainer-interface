class_name LineItem
extends Control

@export var tag: String
@export var vertical_lines: Array[Control]
@export var horizontal_lines: Array[Control]

signal item_pressed(item: LineItem)

signal item_focus_entered(item: LineItem)
signal item_focus_exited(item: LineItem)

signal item_mouse_entered(item: LineItem)
signal item_mouse_exited(item: LineItem)

var is_vertical_selected: bool = false
var is_horizontal_selected: bool = false

func _on_focus_entered() -> void:
	item_focus_entered.emit(self)

func _on_focus_exited() -> void:
	item_focus_exited.emit(self)

func _on_mouse_entered() -> void:
	item_mouse_entered.emit(self)

func _on_mouse_exited() -> void:
	item_mouse_exited.emit(self)

func _on_pressed() -> void:
	item_pressed.emit(self)

func paint(color: Color) -> void:
	paint_vertical_lines(color)
	paint_horizontal_lines(color)

func paint_vertical_lines(color: Color) -> void:
	for node in vertical_lines:
		node.color = color

func paint_horizontal_lines(color: Color) -> void:
	for node in horizontal_lines:
		node.color = color
