@tool 
class_name ValveEl extends Node2D

@onready var sprites = $sprites
@onready var valveLeft = $sprites/ValveLeft
@onready var valveLeftRefusal = $sprites/ValveLeftRefusal
@onready var valveRight = $sprites/ValveRight
@onready var valveRightRefusal = $sprites/ValveRightRefusal
@onready var elMotor = $sprites/ValveElectricMotor
@onready var elMotorRefusal = $sprites/ValveElectricMotorRefusal
@onready var elConn = $sprites/ValveConn
@onready var powerBuffer : bool = false
@onready var controlBuffer : bool = false
@onready var obj_name = {"mainname": "", "subname" : ""}
@onready var player = $signal_play
@onready var refusalButton : PopButton = $"main-cir/refusal"
@onready var refpopchstate : bool = false


const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)
const NOCOLOR_RGB = Color(1, 1, 1, 0)

@export_category("Valve_El") 


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
		return valveLeft.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		valveLeft.rotation_degrees = val
		valveLeftRefusal.rotation_degrees = val
		valveRight.rotation_degrees = val
		valveRightRefusal.rotation_degrees = val
		elConn.rotation_degrees = val
		elMotor.rotation_degrees = val
		elMotorRefusal.rotation_degrees = val


enum VLV_STATE  {ST_UNKNOWN, ST_OPENED, ST_CLOSED, ST_WORKING, ST_OPENING, ST_CLOSING}
@onready var valve_status : VLV_STATE = VLV_STATE.ST_UNKNOWN
@export_enum("неизвестно:0", "открыт:1", "закрыт:2", "в работе:3", "открывается:4", "закрывается:5") var valve_stat : int = VLV_STATE.ST_UNKNOWN: #same as VLV_STATE indexes
	get:
		if not is_node_ready(): await ready
		return valve_status
	set(val):
		if not is_node_ready(): await ready
		#default states
		valve_status = val
		elMotor.modulate = DEFAULT_RGB
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = DEFAULT_RGB
		player.stop()
		if val == VLV_STATE.ST_OPENED: #direct states
			valveLeft.modulate = OPEN_RGB
			valveRight.modulate = OPEN_RGB
		if val == VLV_STATE.ST_CLOSED:
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = CLOSE_RGB
		if val == VLV_STATE.ST_WORKING:
			valveRight.modulate = OPEN_RGB
			valveLeft.modulate = CLOSE_RGB
		if val == VLV_STATE.ST_OPENING:
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = DEFAULT_RGB
			player.play("opening")
		if val == VLV_STATE.ST_CLOSING:
			valveLeft.modulate = DEFAULT_RGB
			valveRight.modulate = OPEN_RGB
			player.play("closing")

@export_group("Refusal")
@export var power: bool = false:
	set(val):
		if not is_node_ready() : await ready
		powerBuffer = val
		if val:
			elMotorRefusal.modulate = REFUSAL_RGB
			valveLeftRefusal.modulate = REFUSAL_RGB
			valveRightRefusal.modulate = REFUSAL_RGB
		else:
			elMotorRefusal.modulate = NOCOLOR_RGB
			valveLeftRefusal.modulate = NOCOLOR_RGB
			valveRightRefusal.modulate = NOCOLOR_RGB
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

func _ready():
	pass 


func _process(delta):
	pass

func _on_child_entered_tree(node):
	if not is_node_ready() : await ready
	printLabel(obj_name["mainname"], obj_name["subname"])




func _on_refusal_b_pressed():
	if not is_node_ready() : await ready
	refpopchstate = not refpopchstate
	refusalButton.pop_childs(refpopchstate)
	pass # Replace with function body.

func _on_refusal_b_pop_hide():
	if not is_node_ready() : await ready
	refpopchstate = false
	refusalButton.pop_childs(refpopchstate)

#popup ordering repair
func _on_maincir_popped(state):
	if state :
		z_index = 5
		sprites.z_index = 5
	else:
		z_index = 0
		sprites.z_index = 0
	pass # Replace with function body.
