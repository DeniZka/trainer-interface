class_name LineMenu
extends Control

signal button_pressed(tag: String, menu: LineMenu)

@export var menu_items: Array[LineItem]

var WHITE_RGB = Color(1, 1, 1)
var LEFTMENU_DARK_BLUE_RGB = Color(0.4, 0.4862745098039216, 0.5568627450980392)
var LEFTMENU_LIGHT_BLUE_RGB = Color(0.6, 0.6588235294117647, 0.7058823529411765)

var line_items_painter: LineItemsPainter = LineItemsPainter.new()

func _ready() -> void:
	for item in menu_items:
		item.item_focus_entered.connect(_on_item_focus_entered)
		item.item_focus_exited.connect(_on_item_focus_exited)
		item.item_mouse_entered.connect(_on_item_mouse_entered)
		item.item_mouse_exited.connect(_on_item_mouse_exited)
		item.item_pressed.connect(_on_item_pressed)

func unselect_all() -> void:
	line_items_painter.unselect(LEFTMENU_DARK_BLUE_RGB, menu_items)

func _on_item_focus_entered(item: LineItem) -> void:
	line_items_painter.hover(item, WHITE_RGB, menu_items)

func _on_item_focus_exited(item: LineItem) -> void:
	line_items_painter.unhover(item, LEFTMENU_DARK_BLUE_RGB, menu_items)

func _on_item_mouse_entered(item: LineItem) -> void:
	line_items_painter.hover(item, LEFTMENU_LIGHT_BLUE_RGB, menu_items)

func _on_item_mouse_exited(item: LineItem) -> void:
	line_items_painter.unhover(item, LEFTMENU_DARK_BLUE_RGB, menu_items)

func _on_item_pressed(item: LineItem) -> void:
	line_items_painter.unselect(LEFTMENU_DARK_BLUE_RGB, menu_items)
	line_items_painter.select(item, WHITE_RGB, menu_items)
	button_pressed.emit(item.tag, self)
