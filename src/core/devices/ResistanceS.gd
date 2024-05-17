@tool 
class_name ResistanceS extends Node2D

@onready var resistanceS = $ResistanceS
@onready var resistanceS2 = $ResistanceS2

@export_category("Resistance Small") 

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return resistanceS.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		resistanceS.rotation_degrees = val
		resistanceS2.rotation_degrees = val
