@tool 
class_name Polygon extends Node2D

@onready var polygon = $Polygon
@onready var obj_name = {"mainname": "", "subname" : ""}

const PURPLE_RGB = Color(0.5490196078431373, 0.2509803921568627, 0.7843137254901961)
const DEFAULT_RGB = Color(1, 1, 1)

@export_category("Polygon") 

func printLabel(mainName, subName):
	for child in get_children():
		if child is Label:
			child.text = mainName + "\n" + subName

@export var main_name : String = "KBAXX":
	set(val):
		if not is_node_ready() : await ready
		obj_name["mainname"] = val
		printLabel(obj_name["mainname"], obj_name["subname"])
	get:
		if not is_node_ready() : await ready
		return obj_name["mainname"]

@export var sub_name : String = "AAXXX":
	set(val):
		if not is_node_ready() : await ready
		obj_name["subname"] = val
		printLabel(obj_name["mainname"], obj_name["subname"])
	get:
		if not is_node_ready() : await ready
		return obj_name["subname"]

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return polygon.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		polygon.rotation_degrees = val

enum POLYGON_STATE  {ST_UNKNOWN, ST_COLORED}
@onready var polygon_status : POLYGON_STATE = POLYGON_STATE.ST_UNKNOWN
@export_enum("неизвестно:0", "окрашен:1") var plgn_state : int = POLYGON_STATE.ST_UNKNOWN: 
	get:
		if not is_node_ready(): await ready
		return polygon_status
	set(val):
		if not is_node_ready(): await ready
		polygon_status = val
		polygon.modulate = DEFAULT_RGB
		if val == POLYGON_STATE.ST_COLORED:
			polygon.modulate = PURPLE_RGB


func _ready():
	pass 

func _process(delta):
	pass

func _on_child_entered_tree(node):
	if not is_node_ready() : await ready
	printLabel(obj_name["mainname"], obj_name["subname"])
