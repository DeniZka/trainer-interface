@tool 
class_name ResistanceL extends Node2D

@onready var resistanceL = $ResistanceL
@onready var resistanceL2 = $ResistanceL2

@export_category("Resistance Large") 

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return resistanceL.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		resistanceL.rotation_degrees = val
		resistanceL2.rotation_degrees = val


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
