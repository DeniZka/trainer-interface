class_name LineItemsPainter
extends RefCounted

func paint(target: LineItem, color: Color, items: Array[LineItem]) -> void:
	if not items[0].is_vertical_selected:
		items[0].paint_horizontal_lines(color)
		
	if not target.is_horizontal_selected:
		target.paint_horizontal_lines(color)
		
	paint_vertical_range_of_items(items[0], target, color, items)

func hover(target: LineItem, color: Color, items: Array[LineItem]) -> void:
	paint(target, color, items)

func unhover(target: LineItem, color: Color, items: Array[LineItem]) -> void:
	paint(target, color, items)

func select(target: LineItem, color: Color, items: Array[LineItem]) -> void:	
	var endIndex: int = items.find(target)
	var range_of_items: Array[LineItem] = items.slice(0, endIndex + 1)

	items[0].paint_horizontal_lines(color)
	items[0].is_horizontal_selected = true
	
	target.paint_horizontal_lines(color)
	target.is_horizontal_selected = true
	
	for item in range_of_items:
		item.is_vertical_selected = true
		item.paint_vertical_lines(color)

func unselect(color: Color, items: Array[LineItem]) -> void:
	for item in items:
		item.is_vertical_selected = false
		item.is_horizontal_selected = false
		item.paint_horizontal_lines(color)
		item.paint_vertical_lines(color)

func paint_vertical_range_of_items(first: LineItem, last: LineItem, color: Color, items: Array[LineItem]) -> void:
	var startIndex: int = items.find(first)
	var endIndex: int = items.find(last)
	
	if startIndex == -1 || endIndex == -1 || startIndex > endIndex:
		return
	
	var range_of_items: Array[LineItem] = items.slice(startIndex, endIndex + 1)
	
	for item in range_of_items:
		if not item.is_vertical_selected:
			item.paint_vertical_lines(color)

func get_pressed_button(items: Array[LineItem]) -> LineItem:
	return null
