@tool 
class_name PumpEl extends Node2D 

@onready var btnArea = $menuArea
@onready var pump = $Ellipse
@onready var elDrive = $ElDrive
@onready var open = $menuArea/menuColShape/Bg/On/On2
@onready var close = $menuArea/menuColShape/Bg/Off/Off2
@onready var rotate = $menuArea/menuColShape/Bg/Rotate/Rotate
@onready var flip = $menuArea/menuColShape/Bg/Flip/Flip
@onready var obj_name = {"mainname": "", "subname" : ""}
@onready var refusalBuffer : bool = false

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const BLACK_RGB = Color(0, 0, 0)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)


@export_category("Pump") 


@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return elDrive.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		elDrive.rotation_degrees = val

enum PUMP_STATE  {ST_UNKNOWN, ST_OPENED, ST_CLOSED} 
@onready var pump_status : PUMP_STATE = PUMP_STATE.ST_UNKNOWN
@export_enum("неизвестно:0", "включен:1", "выключен:2") var pmp_state : int = PUMP_STATE.ST_UNKNOWN: 
	get:
		if not is_node_ready(): await ready
		return pump_status
	set(val):
		if not is_node_ready(): await ready
		pump_status = val
		pump.modulate = DEFAULT_RGB
		elDrive.modulate = BLACK_RGB
		if val == PUMP_STATE.ST_OPENED: 
			if refusal == true:
				elDrive.modulate = REFUSAL_RGB
			pump.modulate = OPEN_RGB
		if val == PUMP_STATE.ST_CLOSED:
			if refusal == true:
				elDrive.modulate = REFUSAL_RGB
			pump.modulate = CLOSE_RGB

@export var refusal: bool = false:
	set(val):
		if not is_node_ready() : await ready
		refusalBuffer = val
		if val:
			elDrive.modulate = REFUSAL_RGB
		else:
			elDrive.modulate = BLACK_RGB
	get:
		if not is_node_ready() : await ready
		return refusalBuffer

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

func _ready():
	pass 

func _process(delta):
	pass

func _on_child_entered_tree(node):
	if not is_node_ready() : await ready
	printLabel(obj_name["mainname"], obj_name["subname"])

func _on_active_area_mouse_entered():
	btnArea.visible = true

func _on_menu_area_mouse_exited():
	btnArea.visible = false


func _on_on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		pump.modulate = OPEN_RGB


func _on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		pump.modulate = CLOSE_RGB


func _on_on_mouse_entered():
	open.modulate = OPEN_RGB

func _on_on_mouse_exited():
	open.modulate = DEFAULT_RGB



func _on_off_mouse_entered():
	close.modulate = CLOSE_RGB

func _on_off_mouse_exited():
	close.modulate = DEFAULT_RGB



func _on_rotate_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		elDrive.rotation_degrees += 90

func _on_rotate_mouse_entered():
	rotate.modulate = DARK_RGB

func _on_rotate_mouse_exited():
	rotate.modulate = DEFAULT_RGB



func _on_flip_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if elDrive.scale.x == -1:
			elDrive.scale.x = 1
		else:
			elDrive.scale.x = -1

func _on_flip_mouse_entered():
	flip.modulate = DARK_RGB

func _on_flip_mouse_exited():
	flip.modulate = DEFAULT_RGB
