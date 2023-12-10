@tool 
class_name ValveEl extends Device

@onready var sprites = $sprites
@onready var valveLeft = $sprites/ValveLeft
@onready var valveLeftRefusal = $sprites/ValveLeftRefusal
@onready var valveRight = $sprites/ValveRight
@onready var valveRightRefusal = $sprites/ValveRightRefusal
@onready var elMotor = $sprites/ValveElectricMotor
@onready var elMotorRefusal = $sprites/ValveElectricMotorRefusal
@onready var accept = $accept
@onready var openb = $"main-cir/open"
@onready var closeb = $"main-cir/close"
@onready var elConn = $sprites/ValveConn
@onready var powerBuffer : bool = false
@onready var controlBuffer : bool = false
#@onready var obj_name = {"mainname": "", "subname" : ""}
@onready var player = $signal_play
@onready var refusalButton : PopButton = $"main-cir/refusal"
@onready var maincir = $"main-cir"
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
		main_name = val
		if not is_node_ready() : await ready
		printLabel(val, sub_name)

@export var sub_name : String = "AAXXX":
	set(val):
		if not is_node_ready() : await ready
		sub_name = val
		printLabel(main_name, val)

@export_range(-180.0, 180.0, 90.0, "degrees") var Rotate: float = 0.0:
	set(val):
		Rotate = val
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

func _init():
	requestd_signals = [
		main_name+sub_name+"_YB01", # Открыть ДУ (ДУ - дистанционное управление) [0/1 boolean]
		main_name+sub_name+"_YB02", #// Закрыть ДУ [0/1 boolean]
		main_name+sub_name+"_YB03", #// Стоп ДУ [0/1 boolean]
		main_name+sub_name+"_YB04", #// Подтвердить команду ДУ [0/1 boolean]
		main_name+sub_name+"_mf_type", #// тип отказа [double]
		main_name+sub_name+"_mf_xq01", #// Жесткость отказа [double]
		main_name+sub_name+"_mf_xb01", #// Отказ введен [0/1 boolean]
		main_name+sub_name+"_mf_yb01", #// Ввести отказ [0/1 boolean]
		main_name+sub_name+"_mf_yb02", #// Удалить отказ [0/1 boolean][
		main_name+sub_name+"_is_state", #СВБУ "Состояние сборный сигнал" [double] 
		main_name+sub_name+"_is_alarm", #СВБУ "Авария сборный сигнал" [double]
		main_name+sub_name+"_is_power" #СВБУ "Питание сборный сигнал" [double]
	]
	
func set_exchange_values(in_signals: Dictionary) -> void:
	pass
	
var to_be_sent : Dictionary = {}

func _on_child_entered_tree(node):
	if not is_node_ready() : await ready
	printLabel(main_name, sub_name)

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
		maincir.outline_color = NOCOLOR_RGB
		z_index = 5
		sprites.z_index = 5
	else:
		accept.pop = false
		z_index = 0
		sprites.z_index = 0
	pass # Replace with function body.

#FIXME: REMOVE
func _on_open_b_pressed():
	accept.pop = true
	accept.outline_color = OPEN_RGB
	accept.text_color = OPEN_RGB
	maincir.outline_color = OPEN_RGB
	to_be_sent.clear()
	to_be_sent[main_name+sub_name+"_YB01"] = true

func set_exchange_data(in_signals: Dictionary) -> void:
	super.set_exchange_data(in_signals)
	#TODO: parse signals and set update self status

func _on_close_b_toggled(is_down):
	if is_down and openb.toggled:
		openb.toggled = false
	send_signals({main_name+sub_name+"_YB02": is_down})
	accept.pop = is_down
	if is_down:
		accept.outline_color = CLOSE_RGB
		accept.text_color = CLOSE_RGB
		maincir.outline_color = CLOSE_RGB
	else:
		accept.outline_color = NOCOLOR_RGB
		accept.text_color = NOCOLOR_RGB
		maincir.outline_color = NOCOLOR_RGB
	#to_be_sent.clear()
	#to_be_sent[main_name+sub_name+"_YB01"] = true

func _on_open_b_toggled(is_down):
	if is_down and closeb.toggled:
		closeb.toggled = false
	send_signals({main_name+sub_name+"_YB01": is_down})
	accept.pop = is_down
	if is_down:
		accept.outline_color = OPEN_RGB
		accept.text_color = OPEN_RGB
		maincir.outline_color = OPEN_RGB
	else:
		accept.outline_color = NOCOLOR_RGB
		accept.text_color = NOCOLOR_RGB
		maincir.outline_color = NOCOLOR_RGB

func _on_accept_b_pressed():
	var result : bool = await send_signals({main_name+sub_name+"_YB04": true}, true)
	if not result:
		print("can't confirm due to timeout")
	send_signals({main_name+sub_name+"_YB04": false})
	openb.toggled = false
	closeb.toggled = false
