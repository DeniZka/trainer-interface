@tool #set design-time usability
class_name ValveRegul extends Node2D #generate class name for node searching type

@onready var btnArea = $menuArea
@onready var valveLeft = $ValveLeft
@onready var valveRight = $ValveRight
@onready var elMotor = $ValveElectricMotor
@onready var elArrow = $ValveElArrow
@onready var powerBuffer : bool = false
@onready var controlBuffer : bool = false
@onready var obj_name = {"mainname": "", "subname" : ""}
@onready var player = $signal_play
@onready var elMotorRefusal = $ValveElectricMotorRefusal

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)
const NOCOLOR_RGB = Color(1, 1, 1, 0)

#export inspector variables
@export_category("Valve_Regul") #create comfort category
enum VLV_STATE  {ST_UNKNOWN, ST_OPENED, ST_CLOSED, ST_WORKING}
@onready var valve_status : VLV_STATE = VLV_STATE.ST_UNKNOWN
@export_enum("неизвестно:0", "открыт:1", "закрыт:2", "в работе:3") var valve_stat : int = VLV_STATE.ST_UNKNOWN: #same as VLV_STATE indexes
	get:
		if not is_node_ready(): await ready
		return valve_status
	set(val):
		if not is_node_ready(): await ready
		#default states
		valve_status = val
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = DEFAULT_RGB
		if val == VLV_STATE.ST_OPENED: #direct states 
			valveLeft.modulate = OPEN_RGB
			valveRight.modulate = OPEN_RGB
		if val == VLV_STATE.ST_CLOSED:
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = CLOSE_RGB
		if val == VLV_STATE.ST_WORKING:
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = OPEN_RGB

enum VLV_MODE {ST_UNKNOWN, ST_AUTO, ST_REMOTE}
@onready var valve_mode : VLV_MODE = VLV_MODE.ST_UNKNOWN
@export_enum("неизвестно:0", "автоматический:1", "удаленный:2") var vlv_mode : int = VLV_MODE.ST_UNKNOWN: #same as VLV_STATE indexes
	get:
		if not is_node_ready(): await ready
		return valve_mode
	set(val):
		if not is_node_ready(): await ready
		#default states
		valve_mode = val
		elMotor.modulate = DEFAULT_RGB
		if val == VLV_MODE.ST_AUTO: #direct states
			elMotor.modulate = OPEN_RGB
		if val == VLV_MODE.ST_REMOTE:
			elMotor.modulate = CLOSE_RGB

@export_group("Refusal")
@export var power: bool = false:
	set(val):
		if not is_node_ready() : await ready
		powerBuffer = val
		if val:
			player.play("refusal")
		else:
			player.stop()
	get:
		if not is_node_ready() : await ready
		return powerBuffer

@export var control: bool = false:
	set(val):
		if not is_node_ready() : await ready
		controlBuffer = val
		if val:
			elMotorRefusal.modulate = REFUSAL_RGB
		else:
			elMotorRefusal.modulate = NOCOLOR_RGB
	get:
		if not is_node_ready() : await ready
		return controlBuffer
@export_group("")

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return valveLeft.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		valveLeft.rotation_degrees = val
		valveRight.rotation_degrees = val
		elMotor.rotation_degrees = val
		elArrow.rotation_degrees = val

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

