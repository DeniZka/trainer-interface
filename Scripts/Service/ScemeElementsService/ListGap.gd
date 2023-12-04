@tool 
class_name ListGap extends Node2D

@onready var shape = $ListGap
@onready var obj_name = {"name": ""}

const BLUE_RGB = Color(0, 0.9411764705882353, 1)
const DEFAULT_RGB = Color(1, 1, 1)

@export_category("List Gap") 

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return shape.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		shape.rotation_degrees = val

enum LISTGAP_STATE  {ST_UNKNOWN, ST_COLORED}
@onready var listGap_status : LISTGAP_STATE = LISTGAP_STATE.ST_UNKNOWN
@export_enum("неизвестно:0", "окрашен:1") var lst_state : int = LISTGAP_STATE.ST_UNKNOWN: 
	get:
		if not is_node_ready(): await ready
		return listGap_status
	set(val):
		if not is_node_ready(): await ready
		listGap_status = val
		shape.modulate = DEFAULT_RGB
		if val == LISTGAP_STATE.ST_COLORED:
			shape.modulate = BLUE_RGB

func printLabel(mainName):
	for child in get_children():
		if child is Label:
			child.text = mainName

@export var main_name : String = "KBAXX":
	set(val):
		if not is_node_ready() : await ready
		obj_name["name"] = val
		printLabel(obj_name["name"])
	get:
		if not is_node_ready() : await ready
		return obj_name["name"]


func _ready():
	pass 

func _process(delta):
	pass

func _on_child_entered_tree(node):
	if not is_node_ready() : await ready
	printLabel(obj_name["name"])
