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

const valve_stat_map = {2:"открыт",3:"открывается",4:"закрыт",5:"закрывается",6:"в проме"}
@export_enum("неизвестно", "открыт", "закрыт", "в проме", "открывается", "закрывается") var valve_stat : String = "неизвестно": #same as VLV_STATE indexes
	set(val):
		valve_stat = val
		if not is_node_ready(): await ready
		elMotor.modulate = DEFAULT_RGB
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = DEFAULT_RGB
		player.stop()
		if val == "открыт": #direct states
			valveLeft.modulate = OPEN_RGB
			valveRight.modulate = OPEN_RGB
		if val == "закрыт":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = CLOSE_RGB
		if val == "в проме":
			valveRight.modulate = OPEN_RGB
			valveLeft.modulate = CLOSE_RGB
		if val == "открывается":
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = DEFAULT_RGB
			player.play("opening")
		if val == "закрывается":
			valveLeft.modulate = DEFAULT_RGB
			valveRight.modulate = OPEN_RGB
			player.play("closing")

@export_group("Refusal")
const power_map = {2:false, 1:true}
@export var power: bool = false:
	set(val):
		power = val
		if not is_node_ready() : await ready
		if val:
			elMotorRefusal.modulate = REFUSAL_RGB
			valveLeftRefusal.modulate = REFUSAL_RGB
			valveRightRefusal.modulate = REFUSAL_RGB
		else:
			elMotorRefusal.modulate = NOCOLOR_RGB
			valveLeftRefusal.modulate = NOCOLOR_RGB
			valveRightRefusal.modulate = NOCOLOR_RGB

const control_map = {2:false, 1:true}
@export var control: bool = false:
	set(val):
		control = val		
		if not is_node_ready() : await ready
		if val:
			elMotorRefusal.modulate = REFUSAL_RGB
		else:
			elMotorRefusal.modulate = NOCOLOR_RGB
@export_group("")

func _ready():
	super._ready()
	update_requested_signals(
		[
			"YB01", # Открыть ДУ (ДУ - дистанционное управление) [0/1 boolean]
			"YB02", #// Закрыть ДУ [0/1 boolean]
			"YB03", #// Стоп ДУ [0/1 boolean]
			"YB04", #// Подтвердить команду ДУ [0/1 boolean]
			"mf_type", #// тип отказа [double]
			"mf_xq01", #// Жесткость отказа [double]
			"mf_xb01", #// Отказ введен [0/1 boolean]
			"mf_yb01", #// Ввести отказ [0/1 boolean]
			"mf_yb02", #// Удалить отказ [0/1 boolean][
			"is_state", #СВБУ "Состояние сборный сигнал" [double] 
			"is_alarm", #СВБУ "Авария сборный сигнал" [double]
			"is_power", #СВБУ "Питание сборный сигнал" [double]
		]
	)
	
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

func _on_close_b_toggled(is_down):
	if is_down and openb.toggled:
		openb.toggled = false
	send_signal("YB02", [is_down])
	accept.pop = is_down
	if is_down:
		accept.outline_color = CLOSE_RGB
		accept.text_color = CLOSE_RGB
		maincir.outline_color = CLOSE_RGB
	else:
		accept.outline_color = NOCOLOR_RGB
		accept.text_color = NOCOLOR_RGB
		maincir.outline_color = NOCOLOR_RGB

func _on_open_b_toggled(is_down):
	if is_down and closeb.toggled:
		closeb.toggled = false
	send_signal("YB01", [is_down])
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
	var result : bool = await send_signal("YB04", true, true)
	if not result:
		print("can't confirm due to timeout")
	send_signal("YB04", [false])
	#FIXME: test
	#if openb.toggled:
		#set_signal_values(get_full_name()+"_is_state", [3])
	#if closeb.toggled:
		#set_signal_values(get_full_name()+"_is_state", [5])
	openb.toggled = false
	closeb.toggled = false

func update_device_state(sig: String, vals: Array):
	match sig:
		"is_state":
			valve_stat = valve_stat_map[int(vals[0])]
		"is_power":
			power = power_map[int(vals[0])]
		"is_alarm":
			control = control_map[int(vals[0])]
