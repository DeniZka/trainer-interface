@tool 
class_name ValveCheck 
extends Device 

@onready var valveLeft = $ValveLeft
@onready var valveRight = $ValveRight

const CLOSE_RGB = Color(0, 0.9176470588235294, 0) 
const OPEN_RGB = Color(1, 0.5803921568627451, 0.1568627450980392) 
const DARK_RGB = Color(0.8, 0.8, 0.8)
const DEFAULT_RGB = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
var kmin: float = 1.0
var kmax: float = 99.0

@export_category("ValveCheck") 

@export_range(-180.0, 180.0, 90.0, "degrees") var rotate: float = 0.0:
	set(val):
		rotate = val
		if not is_node_ready(): await ready
		valveLeft.rotation_degrees = val
		valveRight.rotation_degrees = val
#

enum VLV_STATE  {ST_UNKNOWN, ST_OPENED, ST_CLOSED, ST_OPENEDCLOSED} 
@export_enum("неизвестно:0", "открыт:1", "закрыт:2", "открыт/закрыт:3") var valve_stat : int = VLV_STATE.ST_UNKNOWN: 
	set(val):
		valve_stat = val
		if not is_node_ready(): await ready
		valveLeft.modulate = DEFAULT_RGB
		valveRight.modulate = DEFAULT_RGB
		if val == VLV_STATE.ST_OPENED: 
			valveLeft.modulate = DEFAULT_RGB
			valveRight.modulate = OPEN_RGB
		if val == VLV_STATE.ST_CLOSED:
			valveLeft.modulate = DEFAULT_RGB
			valveRight.modulate = CLOSE_RGB
		if val == VLV_STATE.ST_OPENEDCLOSED:
			valveLeft.modulate = CLOSE_RGB
			valveRight.modulate = OPEN_RGB

func _ready():
	super._ready()
	update_requested_signals([
		"Kmin",
		"Kmax",
		"state_"
	])

func update_device_state(sig: String, vals: Array):
	match sig:
		"Kmin":
			kmin = vals[0]/100
		"Kmax":
			kmax = vals[0]/100
		"state_":
			var st : float = 1.0 - vals[0]
			if st < kmin:
				valve_stat = VLV_STATE.ST_CLOSED
			elif st > kmax:
				valve_stat = VLV_STATE.ST_OPENED
			else:
				valve_stat = VLV_STATE.ST_OPENEDCLOSED
