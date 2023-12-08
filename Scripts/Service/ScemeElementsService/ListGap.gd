@tool 
class_name ListGap extends Node2D

@onready var shape = $ListGap
@onready var text = $text/name
@onready var textColor = $text


@export_category("List Gap") 

@export var scheme_name: String = "name":
	set(val):
		if not is_node_ready(): await ready
		scheme_name = val
		text.text = val

@export_range(-180.0, 180.0, 180.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return shape.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		shape.rotation_degrees = val

@export var text_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		text_color = val
		textColor.modulate = val

@export var shape_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		shape_color = val
		shape.modulate = val
