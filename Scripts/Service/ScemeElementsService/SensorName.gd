@tool 
class_name SensorName extends Node2D

@onready var sensor = $SensorName

@export_category("Sensor Name") 

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return sensor.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		sensor.rotation_degrees = val


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
