@tool 
class_name Arrow extends Node2D

@onready var arrow = $Arrow

@export_category("Arrow") 

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return arrow.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		arrow.rotation_degrees = val
