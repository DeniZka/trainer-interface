@tool 
class_name Tank extends Node2D

@onready var tank = $Tank

@export_category("Tank") 

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return tank.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		tank.rotation_degrees = val
