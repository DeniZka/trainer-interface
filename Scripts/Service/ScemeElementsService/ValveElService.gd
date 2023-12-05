@tool 
class_name ValveEl extends Node2D

@onready var btnArea = $menuArea
@onready var valveLeft = $ValveLeft
@onready var valveRight = $ValveRight
@onready var elMotor = $ValveElectricMotor
@onready var elConn = $ValveConn
@onready var open = $menuArea/menuColShape/Bg/On/On2
@onready var close = $menuArea/menuColShape/Bg/Off/Off2
@onready var CheckValveOnOff = $menuArea/menuColShape/Bg/CheckValveOnOff/CheckValveOnOff
@onready var CheckValveOn = $menuArea/menuColShape/Bg/CheckValveOn/CheckValveOn
@onready var CheckValveOff = $menuArea/menuColShape/Bg/CheckValveOff/CheckValveOff
@onready var motorClose = $menuArea/menuColShape/Bg/Motor/Motor
@onready var rotate = $menuArea/menuColShape/Bg/Rotate/Rotate
@onready var flip = $menuArea/menuColShape/Bg/Flip/Flip
@onready var refusalBuffer : bool = false
@onready var obj_name = {"mainname": "", "subname" : ""}
@onready var player = $signal_play


const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)

@export_category("Valve_El") 
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


@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return valveLeft.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		valveLeft.rotation_degrees = val
		valveRight.rotation_degrees = val
		elMotor.rotation_degrees = val
		elConn.rotation_degrees = val

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
		valveLeft.modulate = OPEN_RGB
		valveRight.modulate = OPEN_RGB

func _on_on_mouse_entered():
	open.modulate = OPEN_RGB

func _on_on_mouse_exited():
	open.modulate = DEFAULT_RGB



func _on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = CLOSE_RGB
		valveRight.modulate = CLOSE_RGB

func _on_off_mouse_entered():
	close.modulate = CLOSE_RGB

func _on_off_mouse_exited():
	close.modulate = DEFAULT_RGB



func _on_check_valve_on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = OPEN_RGB
		valveRight.modulate = CLOSE_RGB

func _on_check_valve_on_off_mouse_entered():
	CheckValveOnOff.modulate = OPEN_RGB

func _on_check_valve_on_off_mouse_exited():
	CheckValveOnOff.modulate = DEFAULT_RGB



func _on_check_valve_on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = OPEN_RGB

func _on_check_valve_on_mouse_entered():
	CheckValveOn.modulate = OPEN_RGB

func _on_check_valve_on_mouse_exited():
	CheckValveOn.modulate = DEFAULT_RGB



func _on_check_valve_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = CLOSE_RGB

func _on_check_valve_off_mouse_entered():
	CheckValveOff.modulate = CLOSE_RGB

func _on_check_valve_off_mouse_exited():
	CheckValveOff.modulate = DEFAULT_RGB



func _on_rotate_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.rotation_degrees += 90
		valveRight.rotation_degrees += 90
		elConn.rotation_degrees += 90
		elMotor.rotation_degrees += 90

func _on_rotate_mouse_entered():
	rotate.modulate = DARK_RGB

func _on_rotate_mouse_exited():
	rotate.modulate = DEFAULT_RGB



func _on_flip_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if valveLeft.scale.x == -1:
			valveLeft.scale.x = 1
			valveRight.scale.x = 1
		else:
			valveLeft.scale.x = -1
			valveRight.scale.x = -1

func _on_flip_mouse_entered():
	flip.modulate = DARK_RGB

func _on_flip_mouse_exited():
	flip.modulate = DEFAULT_RGB



func _on_motor_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		elMotor.modulate = CLOSE_RGB

func _on_motor_mouse_entered():
	motorClose.modulate = CLOSE_RGB

func _on_motor_mouse_exited():
	motorClose.modulate = DEFAULT_RGB
