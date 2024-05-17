@tool 
class_name PumpEl 
extends Device 

@onready var sprites = $sprites
@onready var pump = $sprites/Ellipse
@onready var elDrive = $sprites/ElDrive
@onready var maincir = $"main-cir"
@onready var accept = $accept
@onready var openb = $"main-cir/open"
@onready var closeb = $"main-cir/close"
@onready var elConn = $sprites/ValveConn

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
const BLACK_RGB = Color(0, 0, 0)
const REFUSAL_RGB = Color(0.7568627450980392, 0, 0.7568627450980392)
var buttons : Array[PopButton] = []
var to_send_with_confirm : Dictionary = {}

@export_category("Pump") 

@export_range(-180.0, 180.0, 90.0, "degrees") var rotate: float = 0.0:
	set(val):
		rotate = val
		if not is_node_ready(): await ready
		elDrive.rotation_degrees = val

enum PUMP_STATE  {ST_UNKNOWN, ST_ON, ST_OFF} 
@export_enum("неизвестно:0", "включен:1", "выключен:2") var pmp_state : int = PUMP_STATE.ST_UNKNOWN: 
	set(val):
		pmp_state = val
		if not is_node_ready(): await ready
		pump.modulate = DEFAULT_RGB
		elDrive.modulate = BLACK_RGB
		if val == PUMP_STATE.ST_ON: 
			if refusal == true:
				elDrive.modulate = REFUSAL_RGB
			pump.modulate = OPEN_RGB
		if val == PUMP_STATE.ST_OFF:
			if refusal == true:
				elDrive.modulate = REFUSAL_RGB
			pump.modulate = CLOSE_RGB

@export var refusal: bool = false:
	set(val):
		refusal = val
		if not is_node_ready() : await ready
		if val:
			elDrive.modulate = REFUSAL_RGB
		else:
			elDrive.modulate = BLACK_RGB

func _ready():
	super._ready()
	update_requested_signals(["is_state"])
	
func untuggle_others_except(aliveb: PopButton):
	for b in buttons:
		if aliveb != b and b.toggled:
			b.toggled = false
			
func everyone_outline(color: Color):
	for b in buttons:
		(b as PopButton).outline_color = color
	maincir.outline_color = color
	accept.outline_color = color

func _on_maincir_popped(state):
	if state :
		z_index = 5
		sprites.z_index = 5
	else:
		z_index = 0
		sprites.z_index = 0
		
func update_device_state(sig: String, vals: Array):
	if sig == "is_state":
		pmp_state = int(vals[0])


func _on_close_b_toggled(is_down):
	if is_down:
		untuggle_others_except(closeb)
	#send_signal("YB02", [is_down])
	accept.pop = is_down
	if is_down:
		everyone_outline(CLOSE_RGB)
		to_send_with_confirm = {"YB02": [true]}


func _on_open_b_toggled(is_down):
	if is_down:
		untuggle_others_except(openb)
	#send_signal("YB01", [is_down])
	accept.pop = is_down
	if is_down:
		everyone_outline(OPEN_RGB)
		to_send_with_confirm = {"YB01": [true]}


func _on_refusal_b_toggled(is_down):
	pass # Replace with function body.


func _on_accept_b_pressed():
	to_send_with_confirm.merge({"YB92":[true]})
	send_signals(to_send_with_confirm)
	to_send_with_confirm = {}
	#FIXME: test
	openb.toggled = false
	closeb.toggled = false
