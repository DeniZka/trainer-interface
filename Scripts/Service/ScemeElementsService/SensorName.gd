@tool 
class_name SensorName extends Node2D

@onready var sensorL = $SensorNameL
@onready var sensorS = $SensorNameS
@onready var valNumber = $SensorNameL/Number/Number
@onready var valColor = $SensorNameL/Number
@onready var meanLetter = $SensorNameS/Letter/Letter
@onready var meanColor = $SensorNameS/Letter
@onready var valPanelColor = $SensorNameL
@onready var meanPanelColor = $SensorNameS

@export_category("Sensor Name") 

@export var value: String = "number":
	set(val):
		if not is_node_ready(): await ready
		value = val
		valNumber.text = val

@export var meaning: String = "letters":
	set(val):
		if not is_node_ready(): await ready
		meaning = val
		meanLetter.text = val

@export_group("Colors")
@export var value_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		value_color = val
		valColor.modulate = val

@export var meaning_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		meaning_color = val
		meanColor.modulate = val

@export var value_panel_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		value_panel_color = val
		valPanelColor.modulate = val

@export var meaning_panel_color : Color = Color(1,1,1,1):
	set(val):
		if not is_node_ready(): await ready
		meaning_panel_color = val
		meanPanelColor.modulate = val
@export_group("")
