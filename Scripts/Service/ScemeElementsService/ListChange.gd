@tool 
class_name ListChange extends Node2D

@onready var shape = $ListChange
@onready var text = $text/name
@onready var textColor = $text

const BLUE_RGB = Color(0, 0.9411764705882353, 1)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)

@export_category("List Change") 

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


func _ready():
	pass 

func _process(delta):
	pass


