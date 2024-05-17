class_name LineMenu
extends Control

signal button_pressed(tag: String, menu: LineMenu)

@export var menu_items: Array[LineItem]

@export var colors: LineMenuColors 

var line_items_painter: LineItemsPainter = LineItemsPainter.new()

func _ready() -> void:
	for item in menu_items:
		add_item(item)

func erase_nulls() -> void:
	menu_items = menu_items.filter(func(item): return item != null)

func add_item(item: LineItem) -> void:
	item.item_focus_entered.connect(_on_item_focus_entered)
	item.item_focus_exited.connect(_on_item_focus_exited)
	item.item_mouse_entered.connect(_on_item_mouse_entered)
	item.item_mouse_exited.connect(_on_item_mouse_exited)
	item.item_pressed.connect(_on_item_pressed)

func unselect_all() -> void:
	line_items_painter.unselect(colors.unhover_color, menu_items)

func _on_item_focus_entered(item: LineItem) -> void:
	line_items_painter.hover(item, colors.select_color, menu_items)

func _on_item_focus_exited(item: LineItem) -> void:
	line_items_painter.unhover(item, colors.unhover_color, menu_items)

func _on_item_mouse_entered(item: LineItem) -> void:
	line_items_painter.hover(item, colors.hover_color, menu_items)

func _on_item_mouse_exited(item: LineItem) -> void:
	line_items_painter.unhover(item, colors.unhover_color, menu_items)

func _on_item_pressed(item: LineItem) -> void:
	line_items_painter.unselect(colors.unhover_color, menu_items)
	line_items_painter.select(item, colors.select_color, menu_items)
	button_pressed.emit(item.tag, self)
