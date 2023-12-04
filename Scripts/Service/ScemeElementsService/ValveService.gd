@tool #set design-time usability
class_name Valve extends Node2D #generate class name for node searching type

@onready var btnArea = $menuArea
@onready var valveLeft = $ValveLeft
@onready var valveRight = $ValveRight
@onready var open = $menuArea/menuColShape/Bg/On/On2
@onready var close = $menuArea/menuColShape/Bg/Off/Off2
@onready var CheckValveOnOff = $menuArea/menuColShape/Bg/CheckValveOnOff/CheckValveOnOff
@onready var CheckValveOn = $menuArea/menuColShape/Bg/CheckValveOn/CheckValveOn
@onready var CheckValveOff = $menuArea/menuColShape/Bg/CheckValveOff/CheckValveOff
@onready var rotate = $menuArea/menuColShape/Bg/Rotate/Rotate
@onready var flip = $menuArea/menuColShape/Bg/Flip/Flip
@onready var obj_name = {"mainname": "", "subname" : ""}

var CLOSE_RGB = CustomRGBDto.new(0, 0.9176470588235294, 0) 
var OPEN_RGB = CustomRGBDto.new(1, 0.5803921568627451, 0.1568627450980392) 
var DARK_RGB = CustomRGBDto.new(0.8, 0.8, 0.8)
var DEFAULT_RGB = CustomRGBDto.new(1, 1, 1)



#export inspector variables
@export_category("Valve") #create comfort category

#lets rotate icons
@export_range(-180.0, 180.0, 45.0, "degrees") var Rotate: float = 0.0:
	get:
		if not is_node_ready(): await ready
		return valveLeft.rotation_degrees
	set(val):
		if not is_node_ready(): await ready
		valveLeft.rotation_degrees = val
		valveRight.rotation_degrees = val
#
#Lets colorize by state
enum VLV_STATE  {ST_UNKNOWN, ST_OPENED, ST_CLOSED, ST_OPENING, ST_CLOSING} #ST_UNKNOWN = 0 and etc
const cl_gray = Color(0.5, 0.5, 0.5)
const cl_orange = Color(1, 0.5803921568627451, 0.1568627450980392)
const cl_green = Color(0, 0.9176470588235294, 0)
@onready var player = $signal_play
@onready var valve_status : VLV_STATE = VLV_STATE.ST_UNKNOWN
@export_enum("неизвестно:0", "открыт:1", "закрыт:2", "открывается:3") var valve_stat : int = VLV_STATE.ST_UNKNOWN: #same as VLV_STATE indexes
	get:
		if not is_node_ready(): await ready
		return valve_status
	set(val):
		if not is_node_ready(): await ready
		#default states
		valve_status = val
		player.stop()
		valveLeft.modulate = cl_gray
		valveRight.modulate = cl_gray
		if val == VLV_STATE.ST_OPENED: #direct states
			valveLeft.modulate = cl_orange
			valveRight.modulate = cl_orange
		if val == VLV_STATE.ST_CLOSED:
			valveLeft.modulate = cl_green
			valveRight.modulate = cl_green
		if val == VLV_STATE.ST_OPENING:
			valveRight.modulate = cl_orange
			player.play("opening")

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
		self.valve_stat = VLV_STATE.ST_OPENING
		#чисто проверочные штуки Александр их привяжет к БД и перепишет
		#valveLeft.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)
		#valveRight.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_on_mouse_entered():
	open.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_on_mouse_exited():
	open.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)
		valveRight.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_off_mouse_entered():
	close.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_off_mouse_exited():
	close.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_check_valve_on_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)
		valveRight.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_check_valve_on_off_mouse_entered():
	CheckValveOnOff.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_check_valve_on_off_mouse_exited():
	CheckValveOnOff.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_check_valve_on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)
		valveRight.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_check_valve_on_mouse_entered():
	CheckValveOn.modulate = Color(OPEN_RGB.red, OPEN_RGB.green, OPEN_RGB.blue)

func _on_check_valve_on_mouse_exited():
	CheckValveOn.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_check_valve_off_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)
		valveRight.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_check_valve_off_mouse_entered():
	CheckValveOff.modulate = Color(CLOSE_RGB.red, CLOSE_RGB.green, CLOSE_RGB.blue)

func _on_check_valve_off_mouse_exited():
	CheckValveOff.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_rotate_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		valveLeft.rotation_degrees += 90
		valveRight.rotation_degrees += 90

func _on_rotate_mouse_entered():
	rotate.modulate = Color(DARK_RGB.red, DARK_RGB.green, DARK_RGB.blue)

func _on_rotate_mouse_exited():
	rotate.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)



func _on_flip_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		if valveLeft.scale.x == -1:
			valveLeft.scale.x = 1
			valveRight.scale.x = 1
		else:
			valveLeft.scale.x = -1
			valveRight.scale.x = -1

func _on_flip_mouse_entered():
	flip.modulate = Color(DARK_RGB.red, DARK_RGB.green, DARK_RGB.blue)

func _on_flip_mouse_exited():
	flip.modulate = Color(DEFAULT_RGB.red, DEFAULT_RGB.green, DEFAULT_RGB.blue)